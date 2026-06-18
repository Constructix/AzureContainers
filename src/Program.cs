using Azure.Identity;
using Azure.Messaging.ServiceBus;
using dockerDemo;
using dockerDemo.Customers.Models;
using dockerDemo.Customers.Services;
using dockerDemo.Customers.Services.Products;
using dockerDemo.Quotations.Models;
using dockerDemo.Quotations.Services;
using dockerDemo.ServiceBus.Accessors;
using dockerDemo.ServiceBus.Middleware;
using Microsoft.Azure.Functions.Worker.Builder;
using Microsoft.Extensions.Azure;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Configuration.AzureAppConfiguration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

using Microsoft.Azure.Functions.Worker.Extensions.OpenApi.Extensions;

const string LocalSettings = "local.settings.json";
var builder = FunctionsApplication.CreateBuilder(args);


builder.Configuration.AddJsonFile(LocalSettings, optional: true, reloadOnChange: true)
    .AddEnvironmentVariables();
var appConfigEndpoint = builder.Configuration["AppConfig"];



// Load App Configuration
builder.Configuration.AddAzureAppConfiguration(options =>
{
    Uri endpoint = new Uri(uriString: appConfigEndpoint);
    options.Connect(endpoint, new DefaultAzureCredential())
            .ConfigureKeyVault(kv =>
            {
                
                kv.SetCredential(new DefaultAzureCredential());
            })
           .Select(KeyFilter.Any, LabelFilter.Null)
           .ConfigureRefresh(refreshOptions =>
           {
               refreshOptions.RegisterAll();
           });

    
});

builder.Services.AddAzureClients(async clientBuilder =>
{
    var sbNameSpace = builder.Configuration["Constructix.DockerDemo.ServiceBusNamespace"];

    clientBuilder.AddServiceBusClientWithNamespace(sbNameSpace);
    DefaultAzureCredential credential = new DefaultAzureCredential();
    clientBuilder.UseCredential(credential);

    var queueName = "newOrders";
    clientBuilder.AddClient<ServiceBusSender, ServiceBusClientOptions>((_, _, provider) =>
            provider.GetService(typeof(ServiceBusClient)) switch
            {
                ServiceBusClient client => client.CreateSender(queueName),
                _ => throw new InvalidOperationException("Unable to create ServiceBusClient")
            }).WithName(queueName);

});
builder.Services.AddSingleton<ICorrelationContextAccessor, CorrelationContextAccessor>();
builder.UseMiddleware<CorrelationIdMiddleware>();
SetupServiceData(builder);


builder.Services.AddApplicationInsightsTelemetryWorkerService();
// Add Azure App Configuration middleware to the service collection.
builder.Services.AddAzureAppConfiguration();
// use app config for middleware-> dynamic configuration refresh without redeploying the function app
builder.UseAzureAppConfiguration();

// Configure the Functions Worker (NO ASP.NET Core)
//builder.ConfigureFunctionsWorkerDefaults();




// Build and run
builder.Build().Run();


static void SetupServiceData(FunctionsApplicationBuilder builder)
{


    var customers = new List<Customer>
        {
            new Customer { Name = "Customer X" },
            new Customer { Name = "Customer Y" },
            new Customer { Name = "Customer Z" }
        };


    var quotations = new List<Quotation>
    {
        new Quotation("AXD", DateTimeOffset.UtcNow, customers.First(x=>x.Name.Equals("Customer Y")))
    };

    var products = new List<Product>
            {
               new Product("123AA", "Product1",  DateTimeOffset.UtcNow.AddDays(-35), null),
               new Product("134AQ", "Product2",  DateTimeOffset.UtcNow.AddDays(new  Random().Next(1, 200) * -1),null),
               new Product("1678HW", "Product3",  DateTimeOffset.UtcNow.AddDays(new  Random().Next(1, 200) * -1), null),
               new Product("9723XA", "Product4",  DateTimeOffset.UtcNow.AddDays(new  Random().Next(1, 200) * -1), null)
            };
    
    builder.Services.AddSingleton<IProductService, ProductService>(x => {
        var logger = x.GetRequiredService<ILogger<ProductService>>();  
        return new ProductService(products, logger);
        });

    builder.Services.AddSingleton<ICustomerService, CustomerService>(x =>
    {
        var logger = x.GetRequiredService<ILogger<CustomerService>>();
        return new CustomerService(customers, logger);
    });

    builder.Services.AddSingleton<IQuotationService, QuotationService>(x =>
    {
        var logger = x.GetRequiredService<ILogger<QuotationService>>();
        return new QuotationService(quotations, logger);
    });
}