<!DOCTYPE html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1">
	<title>Keyhole Chooser</title>
	<style>	
		html {		
			height: 100%;	
		}
		body {
			width: 100%;
			height: 100%;
			margin: 0px;		
		}
		.smooth_zoom_preloader {
			background-image: url(<?php echo $subpath; ?>js/preloader.gif);
		}	
		.smooth_zoom_icons {
			background-image: url(<?php echo $subpath; ?>js/icons.png);
		}
	</style>
	<script src="<?php echo $subpath; ?>js/jquery.min.js"></script>
	<script src="<?php echo $subpath; ?>js/jquery.smoothZoom.js"></script>
	<script type="text/javascript">
	var currLevel = 0;
	var imageSelectionType = '<?php echo $type; ?>';
	var placeX, placeY;
	var thingQuad;
	var clicks = new Array();
	jQuery(function($){
		$('#lab').smoothZoom({
			width: '100%',
			height: '100%',
			responsive: true,
			initial_ZOOM: '125',
			zoom_MIN:100,
			zoom_MAX:185,
			reset_TO_ZOOM_MIN: true,
			image_url: '<?php echo $subpath; ?>keyhole_images/<?php echo $type; ?>_<?php echo $image; ?>.jpg',
			onClickEvent: function(x, y){
				var self = this;
				var zoomLevel = self.getZoomData();
				console.log(zoomLevel);

				var newX = x / self.rA;
				var newY = y / self.rA;

				if(imageSelectionType == 'fc'){
					var point = { x: newX, y: newY };
					clicks[currLevel] = point;
					console.log(clicks);

					currLevel++;
					console.log("User Clicked Level " + currLevel + "! (" + newX + "," + newY + ")");

					if(currLevel == 4){
						// done!
						parent.fcKeyholeSelected(clicks[0].x, clicks[0].y,
							clicks[1].x, clicks[1].y,
							clicks[2].x, clicks[2].y,
							clicks[3].x, clicks[3].y
							)
					}
				}
			    else{
					if(currLevel == 0){
						currLevel++;
						console.log("User Clicked Level 1! (" + newX + "," + newY + ")");
						if(imageSelectionType == 'people'){
							parent.peopleKeyholeSelected(newX, newY);
							return;
						}
						else if(imageSelectionType == 'place'){
							placeX = newX;
							placeY = newY;

							// pick which image to load
							var quadToLoad = "1";
							if(x > 512 && y < 512){
								quadToLoad = "2";
							}
							else if(x < 512 && y > 512){
								quadToLoad = "3";
							}
							else if(x > 512 && y > 512){
								quadToLoad = "4";
							}

							console.log("Loaded quad:" + quadToLoad);

							thingQuad = quadToLoad;

							setTimeout(function() {
								self.setToImage('<?php echo $subpath; ?>keyhole_images/thing_<?php echo $image; ?>' + quadToLoad + '.jpg');
								self.focusTo({ zoom:125, speed:1,x:1000,y:1000 });
							},
							400);
						}
					}
					else if(currLevel == 1){
						currLevel++;
						console.log("User Clicked Level 2! (" + newX + "," + newY + ")");
						parent.placeFinalKeyholeSelected(placeX, placeY, thingQuad, newX, newY);
						return;
					}
				}
			}
		});
	});
	</script>
</head>

<body>
  <div id="lab"></div>
</body>
</html>