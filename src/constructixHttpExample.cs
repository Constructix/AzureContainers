using System.Net;
using dockerDemo.Customers.Services;
using dockerDemo.Customers.Services.Products;
using dockerDemo.Quotations.Models;
using dockerDemo.Quotations.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Attributes;
using Microsoft.OpenApi.Models;
using dockerDemo.Customers.Models;

namespace dockerDemo;
public class constructixHttpExample
{
    private readonly ILogger<constructixHttpExample> _logger;
    private readonly ICustomerService _customerService;
    private readonly IProductService _productService;
    private readonly IConfiguration _configuration;
    private readonly IQuotationService _quotationService;
    public constructixHttpExample( ILogger<constructixHttpExample> logger, 
        ICustomerService customerService, 
        IProductService productService,
        IConfiguration configuration,
        IQuotationService quotationService)
    {        
        _logger                 = logger;
       _customerService         = customerService; 
        _productService         = productService;
        _configuration          = configuration;
        _quotationService       = quotationService;
    }

  

    [Function("GetSuppliers")]
    [OpenApiOperation(operationId:"GetSupppliers", tags: new[] { "Supplier"})]
    [OpenApiResponseWithBody(HttpStatusCode.OK, "application/json", typeof(List<Supplier>))]
    public async Task<HttpResponseData> GetSuppliers([HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequestData req)
    {
        _logger.LogInformation("C# HTTP trigger function processed a request to get suppliers.");        
        var suppliers = new List<Supplier>
        {
            new Supplier { Name = "Supplier A" },
            new Supplier { Name = "Supplier B" },
            new Supplier { Name = "Supplier C" }
        };        
        var response = req.CreateResponse(HttpStatusCode.OK);
        await response.WriteAsJsonAsync(suppliers);
        return response;    
    }
    [Function("GetCustomers")]
    [OpenApiOperation(operationId: "GetCustomers", tags: new[] { "Customer" })]
    [OpenApiResponseWithBody(HttpStatusCode.OK, "application/json", typeof(List<Customer>))]
    public async Task<HttpResponseData> GetCustomers([HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequestData req)
    {
        _logger.LogInformation("C# HTTP trigger function processed a request to get customers.");
        var customerList = await _customerService.GetCustomersAsync();        
        var response = req.CreateResponse(HttpStatusCode.OK);
        await response.WriteAsJsonAsync(customerList);    
        return response;
        
    }

    [Function("Products")]
    [OpenApiOperation(operationId: "GetAllProducts", tags: new[] { "Product" })]
    [OpenApiResponseWithBody(HttpStatusCode.OK, "application/json", typeof(List<Product>))]
    public async Task<HttpResponseData> GetProducts([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route ="v1/products")] HttpRequestData req)
    {
        _logger.LogInformation("Trigger to Retrieve all products from Product service.");
        var productList = await _productService.GetProductsAsync();
        var response = req.CreateResponse(HttpStatusCode.OK);
        await response.WriteAsJsonAsync(productList);
        return response;
    }



    [Function("GetQueueName")]
    [OpenApiOperation(operationId: "GetQueueName", tags: new[] { "QueueDetails" })]
    [OpenApiResponseWithBody(HttpStatusCode.OK, "application/json", typeof(QueueDetails))]
    public async Task<HttpResponseData> GetQueueName([HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequestData req)    {
        _logger.LogInformation("C# HTTP trigger function processed a request to get queue name.");
        var queueName = _configuration.GetValue<string>("Constructix.Functions.OrderFunction.SenderQueue") ?? "DefaultQueueName";

        var response = req.CreateResponse(HttpStatusCode.OK);
        await response.WriteAsJsonAsync(new QueueDetails(queueName));
        return response;
    }

    [Function("KeyVaultFoodToGo")]
    [OpenApiOperation(operationId: "GetSubscriptionIdFromKeyVault", tags: new[] { "string" })]
    [OpenApiResponseWithBody(HttpStatusCode.OK, "application/json", typeof(string))]
    public async Task<HttpResponseData> GetKeyVaultFoodToGoSubscriptionId([HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequestData req)
    {
        _logger.LogInformation("C# HTTP trigger function processed a request to get queue name.");
        var subscriptionId = _configuration.GetValue<string>("FoodToGoSubscription") ?? "Not Found";

        var response = req.CreateResponse(HttpStatusCode.OK);
        await response.WriteAsJsonAsync(new Subscription(subscriptionId));
        return response;
    }



    [Function("quotations")]
    [OpenApiOperation(operationId: "GetAllQuotations", tags: new[] { "Quotations" })]
    [OpenApiResponseWithBody(HttpStatusCode.OK, "application/json", typeof(List<Quotation>))]
    public async Task<HttpResponseData> GetQuotations([HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequestData req)
    {   
        var response = req.CreateResponse(HttpStatusCode.OK);
        var quotations = await _quotationService.GetQuotetationsAsync();
     
        await response.WriteAsJsonAsync(quotations);
        return response;
    }

    [Function("newQuotation")]
    [OpenApiOperation(operationId: "Create New Quotation", tags: new[] { "NewQuotation" })]
    [OpenApiResponseWithBody(HttpStatusCode.OK, "application/json", typeof(QuotationAdded))]
    public async Task<HttpResponseData> PostNewQuotation([HttpTrigger(AuthorizationLevel.Anonymous, "post")] HttpRequestData req)
    {
        var newQuotation =await  req.ReadFromJsonAsync<Quotation>();
        if (newQuotation != null)
        {
            var added = await _quotationService.AddQuotationAsync(newQuotation);
            if (added)
            {
                var response = req.CreateResponse(HttpStatusCode.Accepted);
                await response.WriteAsJsonAsync<QuotationAdded>(new QuotationAdded("Quotation added."));
                return response;
            }
            else
            {
                var response = req.CreateResponse(HttpStatusCode.BadRequest);
                return response;
            }
        }
        else {  
            return req.CreateResponse(HttpStatusCode.BadRequest);
        }
    }
    [Function("merchants")]
    public async Task<HttpResponseData> GetMerchants([HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequestData req)
    {
        _logger.LogInformation("Merchant Request");        
        var response = req.CreateResponse(HttpStatusCode.Accepted);
        await response.WriteStringAsync("Merchant request received. More Merchants to come to here");
        return response;
        
    }   
}
public class Supplier
{
    public string Name { get; set; } = string.Empty;
}

public record Subscription(string subscriptionId);
public record QueueDetails(string QueueName);
public record QuotationAdded(string Messsage);