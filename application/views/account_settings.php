<div id="content">
    <form name="accountSettings" id="accountSettings" method="POST" action="<?php echo $exepath; ?>users/saveaccountsettings">
	    <br /><br />
		<input id="penThickness" value="<?php echo $myUser->pen_thickness ?>" /> Pen Thickness 
        <input type="hidden" name="pen_thickness" id="penThicknessValue" value="<?php echo $myUser->pen_thickness ?>" />

        <br /><br />

        <script type="text/javascript">
        function startupSliders(){
    		$("#penThickness").kendoSlider({
                increaseButtonTitle: "Right",
                decreaseButtonTitle: "Left",
                min: 1,
                max: 26,
                smallStep: 1,
                largeStep: 2,
                change: function(e){
                    $("#penThicknessValue").val(e.value);
                }
            }).data("kendoSlider");
    	}

        startupSliders();
        </script>

        <br /><br />
        <button class="k-button" type="button" onclick="saveSettings();">Save</button>
    </form>

    <script type="text/javascript">
        function saveSettings(){
            document.accountSettings.submit();
        }
    </script>
</div>