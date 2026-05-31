using Azure;
using Azure.Identity;
using Azure.Messaging.ServiceBus;
using dockerDemo.Customers.Models;
using dockerDemo.ServiceBus.Accessors;
using Microsoft.AspNetCore.SignalR.Protocol;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Azure;
using Microsoft.Extensions.Logging;
using Microsoft.Identity.Client.ManagedIdentity;
using System.Text;
namespace dockerDemo.ServiceBus;

public class ConstructixServiceBusExample
{
    private readonly ServiceBusSender _serviceBusClient;
    private ICorrelationContextAccessor _correlationContextAccessor;
    private ILogger<ConstructixServiceBusExample> _logger;

    public ConstructixServiceBusExample(IAzureClientFactory<ServiceBusSender> senderFactory,
        ICorrelationContextAccessor correlationContextAccessor,
        ILogger<ConstructixServiceBusExample> logger)
    {
        _serviceBusClient = senderFactory.CreateClient("newOrders");
        _correlationContextAccessor = correlationContextAccessor;
        _logger = logger;

    }

    [Function("NewOrder")]
    public async Task<HttpResponseData> ReceiveNewOrderMessagFunction([HttpTrigger(AuthorizationLevel.Anonymous, "Post")] HttpRequestData requestData,
                                                                        FunctionContext context,
                                                                        CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        var headers = requestData.Headers;
        headers.TryGetValues("X-Forwarded-For", out var values);
        var ip = values?.FirstOrDefault()?.Split(',')[0].Trim();
        ip ??= "unknown";
        _logger.LogInformation("Received request for new Order. {CorrelationId}", _correlationContextAccessor.CorrelationId);
        byte[] buffer = new byte[requestData.Body.Length];
        var s = new Span<byte>(buffer);
        var bytesRead = requestData.Body.Read(s);
        _logger.LogInformation("Sending onto queue");
        var sbMessage = new ServiceBusMessage(System.Text.UTF32Encoding.ASCII.GetString(s));
        
        
        sbMessage.ApplicationProperties.TryAdd("clientIPAddress", ip);
        

        sbMessage.CorrelationId = _correlationContextAccessor.CorrelationId;
        await _serviceBusClient.SendMessageAsync(sbMessage);
        var response = requestData.CreateResponse(System.Net.HttpStatusCode.OK);
        await response.WriteAsJsonAsync<newOrderResponse>(new newOrderResponse($"New Order Received CorrelationId: {sbMessage.CorrelationId} ClientIP: {ip} "));
        return response;

    }

    public record newOrderServiceBusMessage(Customer Customer);
    public record newOrderResponse(string Message);
}
