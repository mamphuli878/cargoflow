package com.college.model;

import java.time.LocalDate;

public class CargoModel {

	private int cargoId;
	private String cargoNumber;
	private String senderName;
	private String senderAddress;
	private String senderPhone;
	private String receiverName;
	private String receiverAddress;
	private String receiverPhone;
	private String description;
	private double weight;
	private String dimensions;
	private CargoTypeModel cargoType;
	private String status;
	private LocalDate shipmentDate;
	private LocalDate expectedDeliveryDate;
	private LocalDate actualDeliveryDate;
	private double shippingCost;
	private String trackingNumber;
	private String notes;
	private String createdBy;

	public CargoModel() {
	}

	public CargoModel(int cargoId, String cargoNumber, String senderName, String senderAddress, String senderPhone,
			String receiverName, String receiverAddress, String receiverPhone, String description, double weight,
			String dimensions, CargoTypeModel cargoType, String status, LocalDate shipmentDate,
			LocalDate expectedDeliveryDate, LocalDate actualDeliveryDate, double shippingCost, String trackingNumber,
			String notes) {
		this.cargoId = cargoId;
		this.cargoNumber = cargoNumber;
		this.senderName = senderName;
		this.senderAddress = senderAddress;
		this.senderPhone = senderPhone;
		this.receiverName = receiverName;
		this.receiverAddress = receiverAddress;
		this.receiverPhone = receiverPhone;
		this.description = description;
		this.weight = weight;
		this.dimensions = dimensions;
		this.cargoType = cargoType;
		this.status = status;
		this.shipmentDate = shipmentDate;
		this.expectedDeliveryDate = expectedDeliveryDate;
		this.actualDeliveryDate = actualDeliveryDate;
		this.shippingCost = shippingCost;
		this.trackingNumber = trackingNumber;
		this.notes = notes;
	}

	public CargoModel(String cargoNumber, String senderName, String senderAddress, String senderPhone,
			String receiverName, String receiverAddress, String receiverPhone, String description, double weight,
			String dimensions, CargoTypeModel cargoType, String status, LocalDate shipmentDate,
			LocalDate expectedDeliveryDate, double shippingCost, String trackingNumber, String notes, String createdBy) {
		this.cargoNumber = cargoNumber;
		this.senderName = senderName;
		this.senderAddress = senderAddress;
		this.senderPhone = senderPhone;
		this.receiverName = receiverName;
		this.receiverAddress = receiverAddress;
		this.receiverPhone = receiverPhone;
		this.description = description;
		this.weight = weight;
		this.dimensions = dimensions;
		this.cargoType = cargoType;
		this.status = status;
		this.shipmentDate = shipmentDate;
		this.expectedDeliveryDate = expectedDeliveryDate;
		this.shippingCost = shippingCost;
		this.trackingNumber = trackingNumber;
		this.notes = notes;
		this.createdBy = createdBy;
	}

	public CargoModel(int cargoId, String cargoNumber, String senderName, String receiverName, CargoTypeModel cargoType,
			String status, double shippingCost) {
		this.cargoId = cargoId;
		this.cargoNumber = cargoNumber;
		this.senderName = senderName;
		this.receiverName = receiverName;
		this.cargoType = cargoType;
		this.status = status;
		this.shippingCost = shippingCost;
	}

	public CargoModel(int cargoId, String cargoNumber, String senderName, String receiverName, String status) {
		this.cargoId = cargoId;
		this.cargoNumber = cargoNumber;
		this.senderName = senderName;
		this.receiverName = receiverName;
		this.status = status;
	}

	// Constructor for tracking
	public CargoModel(String trackingNumber, String description) {
		this.trackingNumber = trackingNumber;
		this.description = description;
	}

	// Getters and Setters
	public int getCargoId() {
		return cargoId;
	}

	public void setCargoId(int cargoId) {
		this.cargoId = cargoId;
	}

	public String getCargoNumber() {
		return cargoNumber;
	}

	public void setCargoNumber(String cargoNumber) {
		this.cargoNumber = cargoNumber;
	}

	public String getSenderName() {
		return senderName;
	}

	public void setSenderName(String senderName) {
		this.senderName = senderName;
	}

	public String getSenderAddress() {
		return senderAddress;
	}

	public void setSenderAddress(String senderAddress) {
		this.senderAddress = senderAddress;
	}

	public String getSenderPhone() {
		return senderPhone;
	}

	public void setSenderPhone(String senderPhone) {
		this.senderPhone = senderPhone;
	}

	public String getReceiverName() {
		return receiverName;
	}

	public void setReceiverName(String receiverName) {
		this.receiverName = receiverName;
	}

	public String getReceiverAddress() {
		return receiverAddress;
	}

	public void setReceiverAddress(String receiverAddress) {
		this.receiverAddress = receiverAddress;
	}

	public String getReceiverPhone() {
		return receiverPhone;
	}

	public void setReceiverPhone(String receiverPhone) {
		this.receiverPhone = receiverPhone;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public double getWeight() {
		return weight;
	}

	public void setWeight(double weight) {
		this.weight = weight;
	}

	public String getDimensions() {
		return dimensions;
	}

	public void setDimensions(String dimensions) {
		this.dimensions = dimensions;
	}

	public CargoTypeModel getCargoType() {
		return cargoType;
	}

	public void setCargoType(CargoTypeModel cargoType) {
		this.cargoType = cargoType;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public LocalDate getShipmentDate() {
		return shipmentDate;
	}

	public void setShipmentDate(LocalDate shipmentDate) {
		this.shipmentDate = shipmentDate;
	}

	public LocalDate getExpectedDeliveryDate() {
		return expectedDeliveryDate;
	}

	public void setExpectedDeliveryDate(LocalDate expectedDeliveryDate) {
		this.expectedDeliveryDate = expectedDeliveryDate;
	}

	public LocalDate getActualDeliveryDate() {
		return actualDeliveryDate;
	}

	public void setActualDeliveryDate(LocalDate actualDeliveryDate) {
		this.actualDeliveryDate = actualDeliveryDate;
	}

	public double getShippingCost() {
		return shippingCost;
	}

	public void setShippingCost(double shippingCost) {
		this.shippingCost = shippingCost;
	}

	public String getTrackingNumber() {
		return trackingNumber;
	}

	public void setTrackingNumber(String trackingNumber) {
		this.trackingNumber = trackingNumber;
	}

	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}

	public String getCreatedBy() {
		return createdBy;
	}

	public void setCreatedBy(String createdBy) {
		this.createdBy = createdBy;
	}

	@Override
	public String toString() {
		return "CargoModel [cargoId=" + cargoId + ", cargoNumber=" + cargoNumber + ", senderName=" + senderName
				+ ", receiverName=" + receiverName + ", description=" + description + ", weight=" + weight
				+ ", cargoType=" + cargoType + ", status=" + status + ", shipmentDate=" + shipmentDate
				+ ", expectedDeliveryDate=" + expectedDeliveryDate + ", shippingCost=" + shippingCost
				+ ", trackingNumber=" + trackingNumber + "]";
	}
}
