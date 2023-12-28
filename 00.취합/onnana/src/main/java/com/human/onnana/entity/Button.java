package com.human.onnana.entity;

public class Button {
    private String coords;
    private String modalId;

    // 생성자, 게터, 세터 등 필요한 메서드를 추가하세요

    public Button(String coords, String modalId) {
        this.coords = coords;
        this.modalId = modalId;
    }

    public String getCoords() {
        return coords;
    }

    public void setCoords(String coords) {
        this.coords = coords;
    }

    public String getModalId() {
        return modalId;
    }

    public void setModalId(String modalId) {
        this.modalId = modalId;
    }
}