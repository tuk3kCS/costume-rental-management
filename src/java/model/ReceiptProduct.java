package java.model;

public class ReceiptProduct {
    private int id;
    private int quantity;
    private int unitPrice;
    private Product product;

    public ReceiptProduct() {}

    public ReceiptProduct(int id, int quantity, int unitPrice, Product product) {
        this.id = id;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.product = product;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(int unitPrice) {
        this.unitPrice = unitPrice;
    }
    
    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }
}

