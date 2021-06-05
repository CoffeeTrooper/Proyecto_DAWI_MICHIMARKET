package org.michimarket.controller;

import org.michimarket.modelo.Producto;
import org.michimarket.repositorio.IProductoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class ProductoController {

	@Autowired
	private IProductoRepository repo;
	
	@GetMapping("/cargar")
	public String cargarProducto( Model model) {
		
		model.addAttribute("producto", new Producto());
		
		return "CRUDProducto"; 
}
	@GetMapping("/listar")
	public  String listadoProducto( Model model ) {
		
		model.addAttribute("lstProductos",repo.findAll());
		return "listadoProductos";
		
	}
	@PostMapping("/actualizar")
	public String buscarProducto(@ModelAttribute Producto p, Model model) {
	
		model.addAttribute("producto", repo.findById(p.getIdproducto()));
		
		return "CRUDProducto";
	}
	@PostMapping("/guardar")
	public String guardarProducto( @ModelAttribute Producto producto ) {
		
		repo.save(producto); 
		
		return "ListadoProductos"; 
	}
	@PostMapping("/eliminar")
	public String eliminarProducto(@ModelAttribute Producto p, Model model) {
		
		//Por completar
		return "ListadoProductos";
	}
}
