<!DOCTYPE html>
<html>
<head>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" type="text/css" href="keatspl.css">
	<link rel="stylesheet" type="text/css" href="plviewer.css">
	<link rel="stylesheet" type="text/css" href="/keatsl.css">
	<title>Paradise Lost, Keats's Annotated Edition</title>
	<meta name="description" content="This document generated from original XML master via XSLT.">
	<meta name="description" content="">
	<meta name="keywords" content="">
	


	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script src="/openseadragon/openseadragon.min.js"></script>

	
<script>



(function(global) {

	// For the page image URL
	global.imgsrc;
		
	// Initializes the first page
	global.firstStart = 1;
	
	// For the OpenSeaDragon instance
	global.viewer;
    
	// For the page number
	global.pageNo;

	// For working with the back button.
	global.historyFlip;

}(this));



	
$(document).ready(function(){

	// Set up starting page
	total = 1;

	if (window.history && window.history.pushState) {

		$(window).on('popstate', function() {

			historyFlip = 1;

			location.reload(true);

		});

	}
	
	
	// Get information from the URL and parse it
	// https://www.w3schools.com/jsref/prop_loc_search.asp
	urlVal = location.search.substring(1);
	urlSplit = urlVal.split("=");
	urlParsed = Number(urlSplit[1]);

	
	if (urlParsed) {
	
		total = urlParsed;		
	
		
	}
	
	//total = total-1;
	changePage(total);
	

	
	

	function changePage(refPage) {
	
	
	div_id = "kpl" + refPage;
	
	$.ajax({
			
			url: "keatspl.php",
			async: false  
			})		   
		   .done(function( response ) {
				
				html = $(response).find("#" + div_id);
				
				// Replace the textual content of the page
				$("#divContent").empty();
				$(response).find("#" + div_id).appendTo("#divContent");
				
				
				// Take the image out of the text content area
				$(".imageFile").remove();
				
				
				// Grab the image URL
				imgsrc = $(response).find("#" + div_id + " .imageFile a").attr( "href" );
				
				// Grab the page number
				pageNo = $(response).find("#" + div_id + " > div.pageNumber").text();
				
				// If the page number is not a number, we'll hide it.
				if (isNaN(pageNo)){

					$('.pageNumber').hide();

				} else {

					$('.pageNumber').show();

				}
				

				// Move around Keats's notes to the right div.
				$("#divNote").empty();
				$("#divContent").find(".writtenNote").appendTo("#divNote");
				
				
				
				// Committing material to the history for pressing the back button
				if (firstStart == 0){
		
					// Make the correct ID appear in the URL
					var stateObj = { foo: "bar" };
					
					history.pushState(stateObj, "", "plviewer.php?pid=" + refPage);
				
				}


				// Start us out on initial page load
				if (firstStart == 1){
		
					firstStart = 0;
					
					openPage(imgsrc);
				
				}
			
		  });


		
		// Set up the dimensions for the viewer

		var newbox;
		
		if (pageNo == "image"){
		
			newbox = new OpenSeadragon.Rect(0.1, 0.13, 0.8, 0.8);
		

		} else if (pageNo == "paratextl") {

			newbox = new OpenSeadragon.Rect(0.1, 0.13, 0.6, 0.6);
			

		} else if (pageNo == "paratextr") {

			newbox = new OpenSeadragon.Rect(0.4, 0.13, 0.6, 0.6);
		

		} else {


			if (parseInt(pageNo) % 2 != 0){
			
				newbox = new OpenSeadragon.Rect(0.4, 0.13, 0.6, 0.6);			
				
			} else {
			
				newbox = new OpenSeadragon.Rect(0.1, 0.13, 0.6, 0.6);
				
			}
			
		}




		
		// Different methods for loading the image, depending on whether it's left- or right-screen.
		// Done this way to manage memory better. 

		if ((pageNo == "paratextr") || (parseInt(pageNo) % 2 != 0)) {

			// Show loading screen
			viewer.addTiledImage({
				tileSource: {
						type: 'image',
						url: 'images/loading.jpg',
						buildPyramid: false
					},
			});

			viewer.viewport.fitBounds(newbox);

			viewer.addTiledImage({
				tileSource: {
						type: 'image',
						url: imgsrc,
						buildPyramid: false
					},
			});
			
			// Position the picture
			viewer.viewport.fitBounds(newbox);


		} else {


			// Show loading screen
			viewer.open({
				tileSource: {
						type: 'image',
						url: 'images/loading.jpg',
						buildPyramid: false
					},
			});

			viewer.open({
				tileSource: {
						type: 'image',
						url: imgsrc,
						buildPyramid: false
					},
			});

			// Position the picture
			viewer.addHandler('open', function() {
		
				viewer.viewport.fitBounds(newbox);

			});

		}


		
	
		// And, update the user-manipulable location box
		$('#inputID').val(total);
		
	
	} //changePage
	
	
	
	
	
	
	
	
	function findNextNote(refPage, upOrDown) {

		// upOrDown: 
		// 1 = look forward
		// 2 = look backwards
			
		
		$.ajax({
			
			url: "keatspl.php",
			async: false 
			})		   
		   .done(function( response ) {
				
				
				// Searches through all the writtenNotes, and finds the first one that is past the current reference page

				// Initialize our previous note button page reference
				lesserPage = 0;
				
				// Cycle through all the written notes
				$(response).find('.writtenNote').each(function(){

					// Grab each reference note
					foundNumber = $(this).closest(".pageWrapper").attr("id");
					
					//regex to replace letters (\D = non-digit characters) with nothing
					foundNumber = parseInt(foundNumber.replace(/\D/g,''));
					

					// Keep replacing the lesserPage value until we iterate past the user's current position
					if (foundNumber < refPage) {
					
						lesserPage = foundNumber;
					
					}
					
					// If next button was pushed and we found a note after the current user position
					if ((foundNumber > refPage) && (upOrDown == 1)) {
						
						total = foundNumber;
						changePage(total);
						
						// break the each loop once we've found the right page
						return false; 						
					}

				});

			});

		// If we're moving forward and the current user page position is past the last note, we run the function again, with page "1" as the reference


		if ((upOrDown == 1) && (foundNumber <= refPage)){
	
			findNextNote(1, 1)
		
		}

		// If we're moving backwards, do the following
		if (upOrDown == 2){


			// Change to the last note before current user page, if there is one.	
			if (lesserPage > 0){


				total = lesserPage;
				changePage(total);

			// If there isn't a note before the current user page, rerun the function from the last page.
			} else {

				findNextNote(390, 2)

			}
		
		}
		
	
	
	
	}
	

	
    $("#nextbutton").click(function(){
		
		total++;
		//div_id = "kpl" + total;
		
		if (total > 390) {
			total = 1;
		}	
		
		changePage(total);
			
    });
	
	
	
	$("#prevbutton").click(function(){
		
		total--;
		
		if (total < 1) {
			total = 390;
		}
		
		changePage(total);
		
    });
	
	
	$("#inputbutton").click(function(){
		
		inputbuttonValue = $('#inputID').val();
		
		
		if (inputbuttonValue < 1) {
	
			inputbuttonValue = 1;
		
		}	
		
		
		if (inputbuttonValue > 390) {
	
			inputbuttonValue = 390;
		
		}	
		
		
		if (inputbuttonValue < 391 && inputbuttonValue > 0) {
	
			total = inputbuttonValue;
		
		}	
		
		
		div_id = "kpl" + total;
		
		changePage(total);
		
		
        
    });
	
	
	
	$("#nextNote").click(function(){
			
		
		findNextNote(total, 1);
		
        
    });
	
	
	$("#prevNote").click(function(){
			
		
		findNextNote(total, 2);
		
        
    });
	




	// This bit of code is for getting page IDs off of hyperlinked references in Keats's notes
	$('body').on('click', 'a', function (theclick){
		
		// Get the parent containing a clicked link
		containingClass = $(this).parent().prop('className')

		// Grab out the pageref if we are in fact dealing with a link in Keats's note; otherwise proceed as normal
		if (containingClass == "noteContent"){
		
			theclick.preventDefault();
			
			linkref = $(this).attr("href");
			
			//regex to replace letters (\D = non-digit characters) with nothing
			linkref = parseInt(linkref.replace(/\D/g,''));
			
			if (linkref) {
				
				total = linkref;
				
				changePage(total);
				
			}
        
		} //containingClass == "noteContent"

    });




	// Array linking page numbers to the start of the proper book.
	var bookList = [33,60,93,117,150,192,221,243,265,302,336,364];

	//Detect when we've selected a new book
	$('#bookSelect').change(function(){

		bookSelection = ( $(this).find("option:selected").attr('value') ); 

		total = bookList[bookSelection - 1];
		changePage(total);

		$('#bookSelect').val("null");


	});
	

	
	
});
</script>
</head>



<body>

	<div id="headerBar">
		<?php
		include '../head.php';
		?>
	</div>
	
	<!-- For everything below the header -->
	
	<div class="centeredText">
		<span class = "workTitle">Keats's Paradise Lost, a Digital Edition</span>

		<br/>

		<span class="mini-header"> <a href="index.php">Return to Introduction</a> </span> &ensp; | &ensp;

		<span class="mini-header"> <a href="keatspl.php" title="Link to full text html of Keats's Paradise Lost (all text on one web page)">View Full Text</a> </span> &ensp; | &ensp;
		<span class="mini-header"> <a href="keatspl.xml" title="Link to the master TEI XML file used to generate this web page">⇩ TEI Master</a> </span> &ensp; | &ensp;

		<span class="mini-header"> Page Scan Repository: <a href="https://curate.nd.edu/show/7w62f764t1z" title="Link to Curate ND repository containing page images for Volume 1">Vol. 1</a> and <a href="https://curate.nd.edu/show/x633dz0486k" title="Link to Curate ND repository containing page images for Volume 2">Vol. 2</a> </span>



	</div>

	<div id="plcontentWrapper">

		
		<form style="display: inline;" >
			<label for="pid">Location ID (not page): </label>
			<input id="inputID" name="pid" type="number" min="1" max="390" size="4" value="">
			<input type="submit" value="Go">
			
		</form>

		&ensp;


		Book: 

		<select id="bookSelect">
			<option value="null"></option>
			<option value="1">Book 1</option>
			<option value="2">Book 2</option>
			<option value="3">Book 3</option>
			<option value="4">Book 4</option>
			<option value="5">Book 5</option>
			<option value="6">Book 6</option>
			<option value="7">Book 7</option>
			<option value="8">Book 8</option>
			<option value="9">Book 9</option>
			<option value="10">Book 10</option>
			<option value="11">Book 11</option>
			<option value="12">Book 12</option>
		</select>

		<br/>
		
		
	
	
		<span class="navLine">
			
			<button id="prevbutton">< Page</button>
			<button id="nextbutton"> Page ></button>
			
			<button id="prevNote"><< Previous Note</button>
			<button id="nextNote">Next Note >></button>

		</span>




		<div id="mainContainer">
		
			<div id="pageImage"
				 class="openseadragon">
				<script type="text/javascript">
				
					function openPage(imgsrc){
					
				
						viewer = OpenSeadragon({
							id:            "pageImage",
							prefixUrl:     "/openseadragon/images/",
							tileSources:   {
								type: 'image',
								url: '../images/loading.jpg',
								buildPyramid: false
							},
							tabIndex: "" //<!-- This presents it from autopanning when you move the image around. -->
										//<!-- Per: https://github.com/openseadragon/openseadragon/issues/954 -->
										//<!-- And: https://github.com/openseadragon/openseadragon/pull/805 -->
										
							
							
							
						});
						
						
						
						viewer.addHandler('open', function() {
							var box1 = new OpenSeadragon.Rect(0.1, 0.13, 0.8, 0.8);
							viewer.viewport.fitBounds(box1);
						});



						// Show first image
						viewer.open({
							tileSource: {
									type: 'image',
									url: imgsrc,
									buildPyramid: false
								},
			
			
							});
					
					} //openPage
					
					

					
				</script>
				<noscript>
					<p>OpenSeadragon is not available unless JavaScript is enabled.</p>
					<img src='https://openseadragon.github.io/example-images/grand-canyon-landscape-overlooking.jpg'
						 height='600'/>
				</noscript>
			</div>
			
			<div id="divContent"> </div>
			<div id="divNote"> </div>
			
		</div>
		
	</div>
	
	
	<div id="footerBar">
		<?php
		include 'footer.php';
		?>
	</div>








</body>
</html>
