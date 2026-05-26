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
using System.Net;

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
        _logger = logger;
       _customerService = customerService; 
        _productService = productService;
        _configuration = configuration;
        _quotationService = quotationService;

    }

    [Function("constructixHttpExample")]
    public   async Task<HttpResponseData> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequestData req)
    {

        _logger.LogInformation("In ConstructixHttpExample");
        var response = req.CreateResponse(HttpStatusCode.OK);
        response.WriteStringAsync("Welcome to Azure functions the next stage!!!");
        return response;
        
    }

    [Function("GetSuppliers")]
    public async Task<HttpResponseData> GetSuppliers([HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequestData req)
    {
        _logger.LogInformation("C# HTTP trigger function processed a request to get suppliers.");

        
        var suppliers = new List<Supplier>
        {
            new Supplier { Name = "Supplier A" },
            new Supplier { Name = "Supplier B" },
            new Supplier { Name = "Supplier C" }
        };
        //return new OkObjectResult( suppliers); 
        var response = req.CreateResponse(HttpStatusCode.OK);
        await response.WriteAsJsonAsync(suppliers);
        return response;    
    }
    [Function("GetCustomers")]
    public async Task<HttpResponseData> GetCustomers([HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequestData req)
    {
        _logger.LogInformation("C# HTTP trigger function processed a request to get customers.");


        var customerList = await _customerService.GetCustomersAsync();
        
        var response = req.CreateResponse(HttpStatusCode.OK);
        await response.WriteAsJsonAsync(customerList);    
        return response;
        
    }

    [Function("Products")]
    public async Task<HttpResponseData> GetProducts([HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequestData req)
    {
        _logger.LogInformation("Trigger to Retrieve all products from Product service.");
        var productList = await _productService.GetProductsAsync();
        var response = req.CreateResponse(HttpStatusCode.OK);
        await response.WriteAsJsonAsync(productList);
        return response;
    }



    [Function("GetQueueName")]
    public async Task<HttpResponseData> GetQueueName([HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequestData req)    {
        _logger.LogInformation("C# HTTP trigger function processed a request to get queue name.");
        var queueName = _configuration.GetValue<string>("Constructix.Functions.OrderFunction.SenderQueue") ?? "DefaultQueueName";

        var response = req.CreateResponse(HttpStatusCode.OK);
        await response.WriteAsJsonAsync(new QueueDetails(queueName));
        return response;
    }

    [Function("quotations")]
    public async Task<HttpResponseData> GetQuotations([HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequestData req)
    {   
        var response = req.CreateResponse(HttpStatusCode.OK);
        var quotations = await _quotationService.GetQuotetationsAsync();
     
        await response.WriteAsJsonAsync(quotations);
        return response;
    }

    [Function("newQuotation")]
    public async Task<HttpResponseData> PostNewQuotation([HttpTrigger(AuthorizationLevel.Anonymous, "post")] HttpRequestData req)
    {
        var newQuotation =await  req.ReadFromJsonAsync<Quotation>();
        var added =  await _quotationService.AddQuotationAsync(newQuotation);
        if(added)
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

public record QueueDetails(string QueueName);
public record QuotationAdded(string Messsage);