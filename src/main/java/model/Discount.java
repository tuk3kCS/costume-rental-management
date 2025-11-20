package model;

public class Discount {
    private int id;
    private String discountCode;
    private int amount;

    public Discount() {}

    public Discount(int id, String discountCode, int amount) {
        this.id = id;
        this.discountCode = discountCode;
        this.amount = amount;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getDiscountCode() {
        return discountCode;
    }

    public void setDiscountCode(String discountCode) {
        this.discountCode = discountCode;
    }

    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }
}



