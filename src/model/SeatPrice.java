package model;

public class SeatPrice {

    private String category;
    private double basePrice;
    private double discountPercentage;
    private double finalPrice;

    public SeatPrice(String category, double basePrice, double discountPercentage, double finalPrice) {
        this.category = category;
        this.basePrice = basePrice;
        this.discountPercentage = discountPercentage;
        this.finalPrice = finalPrice;
    }

    // Getters and Setters
    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public double getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(double basePrice) {
        this.basePrice = basePrice;
    }

    public double getDiscountPercentage() {
        return discountPercentage;
    }

    public void setDiscountPercentage(double discountPercentage) {
        this.discountPercentage = discountPercentage;
    }

    public double getFinalPrice() {
        return finalPrice;
    }

    public void setFinalPrice(double finalPrice) {
        this.finalPrice = finalPrice;
    }

    @Override
    public String toString() {
        return "SeatPrice{" +
                "category='" + category + '\'' +
                ", basePrice=" + basePrice +
                ", discountPercentage=" + discountPercentage +
                ", finalPrice=" + finalPrice +
                '}';
    }
}