using Microsoft.Extensions.Logging;

namespace dockerDemo.Customers.Services;

public class CustomerService(List<Customer> customers, ILogger<CustomerService> logger) : ICustomerService
{
    
    public  Task<IEnumerable<Customer>> GetCustomersAsync()
    {        
        logger.LogInformation("IN customer service, returning {totalCustomers}", customers.Count());
        return Task.FromResult<IEnumerable<Customer>>(customers);
    }
}
