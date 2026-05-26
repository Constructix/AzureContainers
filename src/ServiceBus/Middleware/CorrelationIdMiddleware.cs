using dockerDemo.ServiceBus.Accessors;
using Microsoft.AspNetCore.Http;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Middleware;
using System;
using System.Collections.Generic;
using System.Text;

namespace dockerDemo.ServiceBus.Middleware
{
    using Microsoft.Azure.Functions.Worker;
    using Microsoft.Azure.Functions.Worker.Middleware;

    public class CorrelationIdMiddleware : IFunctionsWorkerMiddleware
    {
        private readonly ICorrelationContextAccessor _accessor;

        public CorrelationIdMiddleware(ICorrelationContextAccessor accessor)
        {
            _accessor = accessor;
        }

        public async Task Invoke(FunctionContext context, FunctionExecutionDelegate next)
        {
            // Try to read incoming correlationId from headers
            var correlationId = context
                .BindingContext
                .BindingData
                .TryGetValue("Headers", out var headersObj)
                    && headersObj is IReadOnlyDictionary<string, object> headers
                    && headers.TryGetValue("x-correlation-id", out var cidObj)
                ? cidObj?.ToString()
                : null;

            // If none, generate one
            _accessor.CorrelationId = correlationId ?? Guid.NewGuid().ToString();

            // Add to FunctionContext for logging
            context.Items["CorrelationId"] = _accessor.CorrelationId;

            await next(context);
        }
    }
}
