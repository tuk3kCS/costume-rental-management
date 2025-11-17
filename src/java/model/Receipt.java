package java.model;

import java.util.Date;
import java.util.ArrayList;

public class Receipt {
    private int id;
    private Date createdDate;
    private Staff staff;
    private Provider provider;
    private ArrayList<ReceiptProduct> products;
    private Discount discount;

    public Receipt() {
        this.products = new ArrayList<ReceiptProduct>();
    }

    public Receipt(int id, Date createdDate, Staff staff, Provider provider, ArrayList<ReceiptProduct> products, Discount discount) {
        this.id = id;
        this.createdDate = createdDate;
        this.staff = staff;
        this.provider = provider;
        this.products = products;
        this.discount = discount;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public Staff getStaff() {
        return staff;
    }

    public void setStaff(Staff staff) {
        this.staff = staff;
    }

    public Provider getProvider() {
        return provider;
    }

    public void setProvider(Provider provider) {
        this.provider = provider;
    }

    public ArrayList<ReceiptProduct> getProducts() {
        return products;
    }

    public void setProducts(ArrayList<ReceiptProduct> products) {
        this.products = products;
    }

    public Discount getDiscount() {
        return discount;
    }

    public void setDiscount(Discount discount) {
        this.discount = discount;
    }
}



