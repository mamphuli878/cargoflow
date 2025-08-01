package com.cargo.controller;

import java.io.IOException;

import com.cargo.model.CargoModel;
import com.cargo.service.CargoService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * TrackingController handles cargo tracking requests.
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/track" })
public class TrackingController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final CargoService cargoService = new CargoService();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.getRequestDispatcher("/WEB-INF/pages/track.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String trackingNumber = req.getParameter("trackingNumber");

		if (trackingNumber == null || trackingNumber.trim().isEmpty()) {
			req.setAttribute("error", "Please enter a tracking number.");
			req.getRequestDispatcher("/WEB-INF/pages/track.jsp").forward(req, resp);
			return;
		}

		CargoModel cargo = cargoService.trackCargo(trackingNumber.trim());

		if (cargo != null) {
			req.setAttribute("cargo", cargo);
			req.setAttribute("success", "Cargo found successfully!");
		} else {
			req.setAttribute("error", "No cargo found with tracking number: " + trackingNumber);
		}

		req.setAttribute("trackingNumber", trackingNumber);
		req.getRequestDispatcher("/WEB-INF/pages/track.jsp").forward(req, resp);
	}
}
