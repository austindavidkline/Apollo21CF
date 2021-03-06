/**
* Manage Photos
* It will be your responsibility to fine tune this template, add validations, try/catch blocks, logging, etc.
*/
component{

	// DI Virtual Entity Service
	property name="photoService" inject="PhotoService@apollo21";

	// HTTP Method Security
	this.allowedMethods = {
		index = "GET", new = "GET", edit = "GET", delete = "POST,DELETE", save = "POST,PUT"
	};

	/**
	* preHandler()
	*/
	function preHandler(event,rc,prc){
		event.paramValue("format","html");
	}

	/**
	* Listing
	*/
	function index(event,rc,prc){
		// Get all Photos
		rc.Photos = photoService.getAll();

		// RESTful Switch
		switch(rc.format){
			// xml,json,jsont,wddx are by default.  Add your own or remove
			case "xml" : case "json" : case "jsont" : case "wddx" :{
				event.renderData(data=rc.Photos,type=rc.format);
				break;
			}
			// HTML
			default:{
				event.setView("Photos/index");
			}
		}
	}

	/**
	* New Form
	*/
	function new(event,rc,prc){

		// get new Photo
		rc.Photo = photoService.new();

		event.setView("Photos/new");
	}

	/**
	* Edit Form
	*/
	function edit(event,rc,prc){

		// get persisted Photo
		rc.Photo = photoService.get( rc.photoID );

		event.setView("Photos/edit");
	}

	/**
	* View Photo mostly used for RESTful services only.
	*/
	function show(event,rc,prc){

		// Get requested entity by id
		rc.Photo = photoService.get( rc.photoID );

		switch(rc.format){
			// xml,json,jsont,wddx are by default.  Add your own or remove
			case "xml" : case "json" : case "jsont" : case "wddx" :{
				event.renderData(data=rc.Photo,type=rc.format);
				break;
			}
			// HTML
			default:{
				setNextEvent('explorer.photos');
			}
		}
	}

	/**
	* Save and Update
	*/
	function save(event,rc,prc){

		// get Photo to persist or update and populate it with incoming form
		rc.Photo = populateModel(model=photoService.get( rc.photoID ),exclude="photoID");

		// Do your validations here

		// Save it
		photoService.save( rc.Photo );

		// RESTful Handler
		switch(rc.format){
			// xml,json,jsont,wddx are by default.  Add your own or remove
			case "xml" : case "json" : case "jsont" : case "wddx" :{
				event.renderData(data=rc.Photo,type=rc.format,location="/Photos/show/#rc.Photo.getphotoID()#");
				break;
			}
			// HTML
			default:{
				// Show a nice messagebox
				getplugin("MessageBox").info("Photo Created!");
				// Redirect to listing
				setNextEvent('explorer.photos');
			}
		}
	}

	/**
	* Delete
	*/
	function delete(event,rc,prc){

		// Delete record by ID
		var removed = photoService.deleteById( rc.photoID );

		// RESTful Handler
		switch(rc.format){
			// xml,json,jsont,wddx are by default.  Add your own or remove
			case "xml" : case "json" : case "jsont" : case "wddx" :{
				var restData = {deleted=removed};
				event.renderData(data=restData,type=rc.format);
				break;
			}
			// HTML
			default:{
				// Show a nice messagebox
				getplugin("MessageBox").warn("Photo Poofed!");
				// Redirect to listing
				setNextEvent('Photos');
			}
		}
	}

}