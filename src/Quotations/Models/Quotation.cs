using dockerDemo.Customers.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace dockerDemo.Quotations.Models
{
    public record Quotation(string id, DateTimeOffset Created, Customer Customer);
}
