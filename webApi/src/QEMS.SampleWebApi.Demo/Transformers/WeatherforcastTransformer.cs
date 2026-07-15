using Microsoft.AspNetCore.OpenApi;
using Microsoft.OpenApi;


namespace QEMS.SampleWebApi.Demo.Transformers;

public class IntIsNoStringSchemaTransformer : IOpenApiSchemaTransformer
{
    public Task TransformAsync(
        OpenApiSchema schema,
        OpenApiSchemaTransformerContext context,
        CancellationToken cancellationToken)
    {
        if (schema.Properties is null)
        {
            return Task.CompletedTask;
        }

        foreach (var kvp in schema.Properties)
        {
            if (kvp.Value is OpenApiSchema propertySchema &&
                propertySchema.Format == "int32" &&
                propertySchema.Type is { } type &&
                type.HasFlag(JsonSchemaType.String))
            {
                propertySchema.Type = JsonSchemaType.Integer;
                propertySchema.Pattern = null;
            }
        }

        return Task.CompletedTask;
    }

}