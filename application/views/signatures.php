<h1>Manage Documents</h1>

<p>List of all documents <button class="k-button" type="button" onclick="window.location='<?php echo $exepath; ?>documents/add'">Add Document</button></p>  

<div id="example" class="k-content">
<div id="docu_grid"  style="font-size:11px;"> </div>
<script>
    $(document).ready(function() {
        $("#docu_grid").kendoGrid({
            dataSource: {
                type: "jsonp",
                serverPaging: true,
                serverSorting: true,
                pageSize: 30,
                transport: {
                    read: "<?php echo $exepath; ?>documents/documents_service"
                },
                schema: {
		            data: function(result) {
		                  return result.Result || result;
		            },
		            total: function(result) {
		                  return result.PageSize || result.length || 0;
		            }
		        }
            },
            scrollable: false,
            sortable: true,
            pageable: {
    			pageSize: 30
  			},
            columns: [
                { field: "document_id", title: "Action", width: 5, template: "<a href='<?php echo $exepath; ?>documents/review?document_id=#: document_id #'>Review</a> | <a href='<?php echo $exepath; ?>documents/edit?document_id=#: document_id #'>Edit</a> | <a href='javascript:deleteDocu(#: document_id #)'>Delete</a>"},
                //{ field: "user_id", title: "U_id", width: 40 },
                //{ field: "name", title: "User", width: 10 }, // no need to show user's own name
                { field: "title", title: "Title", width: 20 },
                //{ field: "content", title: "Content", width: 90 }, // could be too long to display. see content in review
                { field: "status", title: "Status", width: 5 },
                { field: "date_added", title: "Date added/edited", width: 20 },
                ]
        });
        
    });

function deleteDocu(document_id){
    if(confirm("Are you sure you want to delete this document?")){
        window.location = '<?php echo $exepath; ?>documents/delete?document_id=' + document_id;
    }
}
</script>
</div>


