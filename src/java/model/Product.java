package java.model;

import java.util.ArrayList;

public class Product {
    private int id;
    private String name;
    private String size;
    private String color;
    private ArrayList<ProductDiscount> productDiscount;

    public Product() {}

    public Product(int id, String name, String size, String color, ArrayList<ProductDiscount> productDiscount) {
        this.id = id;
        this.name = name;
        this.size = size;
        this.color = color;
        this.productDiscount = productDiscount;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public ArrayList<ProductDiscount> getProductDiscount() {
        return productDiscount;
    }

    public void setProductDiscount(ArrayList<ProductDiscount> productDiscount) {
        this.productDiscount = productDiscount;
    }
}

