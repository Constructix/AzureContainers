using QEMS.SampleWebApi.Demo.Transformers;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddScoped<IMessageWriter, LoggingMessageWriter>();
builder.Services.AddControllers();
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi

builder.Services.AddOpenApi(options =>
{
    options.AddSchemaTransformer<IntIsNoStringSchemaTransformer>();
    options.OpenApiVersion = Microsoft.OpenApi.OpenApiSpecVersion.OpenApi3_0;

    options.AddDocumentTransformer((document, context, ct) =>
{
            document.Info.Title = "WeatherForecast API";
            document.Info.Version = "1.0";
            return Task.CompletedTask;
        });

});
var app = builder.Build();
app.UseMyCustomMiddleWare();
// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();



public interface IMessageWriter
{
    void Write(string message);
}
