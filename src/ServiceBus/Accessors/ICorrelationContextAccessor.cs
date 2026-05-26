namespace dockerDemo.ServiceBus.Accessors
{
    public interface ICorrelationContextAccessor
    {
        string? CorrelationId { get; set; }
    }
}