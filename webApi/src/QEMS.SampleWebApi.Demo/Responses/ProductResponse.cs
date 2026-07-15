using QEMS.SampleWebApi.Demo.Helpers;
using System.Text.Json.Serialization;

namespace QEMS.SampleWebApi.Demo.Responses;

public class ProductResponse
{
    public string Name { get; set; }
    public int Quantity { get; set; }
    public DateTimeOffset Created { get; set; }
    [JsonPropertyName("UnitPrice")]
    [JsonConverter(typeof(DecimalAsStringConverter))]
    public decimal UnitPrice { get; set; }

}
