package java.model;

public class ProductDiscount extends Discount {

    public ProductDiscount() {
        super();
    }

    public ProductDiscount(int id, String discountCode, int amount, String provider) {
        super(id, discountCode, amount, provider);
    }
}


