package java.model;

public class ReceiptDiscount extends Discount {
    
    public ReceiptDiscount() {
        super();
    }

    public ReceiptDiscount(int id, String discountCode, int amount, String provider) {
        super(id, discountCode, amount, provider);
    }
}

