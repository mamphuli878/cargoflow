package com.college.model;

public class CargoTypeModel {

	private int cargoTypeId;
	private String name;
	private String description;
	private double ratePerKg;
	private String category;

	public CargoTypeModel() {
	}

	public CargoTypeModel(String name, String description, double ratePerKg, String category) {
		this.name = name;
		this.description = description;
		this.ratePerKg = ratePerKg;
		this.category = category;
	}

	public CargoTypeModel(String name) {
		this.name = name;
	}

	public CargoTypeModel(int cargoTypeId, String name, String description, double ratePerKg, String category) {
		this.cargoTypeId = cargoTypeId;
		this.name = name;
		this.description = description;
		this.ratePerKg = ratePerKg;
		this.category = category;
	}

	public int getCargoTypeId() {
		return cargoTypeId;
	}

	public void setCargoTypeId(int cargoTypeId) {
		this.cargoTypeId = cargoTypeId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public double getRatePerKg() {
		return ratePerKg;
	}

	public void setRatePerKg(double ratePerKg) {
		this.ratePerKg = ratePerKg;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	@Override
	public String toString() {
		return "CargoTypeModel [cargoTypeId=" + cargoTypeId + ", name=" + name + ", description=" + description
				+ ", ratePerKg=" + ratePerKg + ", category=" + category + "]";
	}
}
