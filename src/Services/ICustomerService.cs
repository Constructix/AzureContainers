namespace dockerDemo.Customers.Services;

public interface ICustomerService
{
    Task <IEnumerable<Customer>> GetCustomersAsync();
}   
