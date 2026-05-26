namespace dockerDemo;

public record Product(string Sku, string Name, DateTimeOffset EffectiveFrom, DateTimeOffset? EffectiveTo);
