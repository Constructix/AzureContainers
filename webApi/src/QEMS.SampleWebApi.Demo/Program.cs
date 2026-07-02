var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddScoped<IMessageWriter, LoggingMessageWriter>();
builder.Services.AddControllers();
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi(options=>
{
   // options.OpenApiVersion = Microsoft.OpenApi.OpenApiSpecVersion.OpenApi3_1;
    
        options.AddDocumentTransformer((document, context, ct) =>
        {
            document.Info.Title = "My API";
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
