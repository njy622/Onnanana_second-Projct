package com.human.onnana.entity;

public class Button {
    private String coordinates;
    private String modalId;
    private String buttonName;

    public Button(String coordinates, String modalId, String buttonName) {
        this.coordinates = coordinates;
        this.modalId = modalId;
        this.buttonName = buttonName;
    }

	public String getCoordinates() {
		return coordinates;
	}

	public void setCoordinates(String coordinates) {
		this.coordinates = coordinates;
	}

	public String getModalId() {
		return modalId;
	}

	public void setModalId(String modalId) {
		this.modalId = modalId;
	}

	public String getButtonName() {
		return buttonName;
	}

	public void setButtonName(String buttonName) {
		this.buttonName = buttonName;
	}
    
    // Getter 및 Setter 메서드 생략 (필요에 따라 추가)
    
    
}