package com.human.onnana.entity;

public class WeatherInfo {
    private String imageUrl;
    private String lifeIndex;
    private int index;
    private String comment;

    // 생성자, getter, setter 등...

    public WeatherInfo(String imageUrl, String lifeIndex, int index, String comment) {
        this.imageUrl = imageUrl;
        this.lifeIndex = lifeIndex;
        this.index = index;
        this.comment = comment;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getLifeIndex() {
        return lifeIndex;
    }

    public void setLifeIndex(String lifeIndex) {
        this.lifeIndex = lifeIndex;
    }

    public int getIndex() {
        return index;
    }

    public void setIndex(int index) {
        this.index = index;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }
}
