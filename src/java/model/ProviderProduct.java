package java.model;

public class ProviderProduct {
    private int id;
    private int unitPrice;
    private Provider provider;
    private Product product;

    public ProviderProduct() {}

    public ProviderProduct(int id, int unitPrice, Provider provider, Product product) {
        this.id = id;
        this.unitPrice = unitPrice;
        this.provider = provider;
        this.product = product;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(int unitPrice) {
        this.unitPrice = unitPrice;
    }

    public Provider getProvider() {
        return provider;
    }

    public void setProvider(Provider provider) {
        this.provider = provider;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }
}



