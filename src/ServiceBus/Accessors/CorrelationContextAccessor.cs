using System;
using System.Collections.Generic;
using System.Text;

namespace dockerDemo.ServiceBus.Accessors
{
    public class CorrelationContextAccessor : ICorrelationContextAccessor
    {
        public string? CorrelationId { get; set; }
    }
}
