<h1>Admin Panel</h1>

<a href="<?php echo $exepath; ?>users">User List</a> | <a href="<?php echo $exepath; ?>users/auditlogs">Audit Logs</a> | <a href="<?php echo $exepath; ?>users/approve">Approve Documents</a><br /><br />

<p>List of all documents </p>  

<div id="example" class="k-content">
<div id="docu_grid_1"  style="font-size:11px;"> </div>
<script>
    $(document).ready(function() {
        $("#docu_grid_1").kendoGrid({
            dataSource: {
                type: "jsonp",
                serverPaging: true,
                serverSorting: true,
                pageSize: 30,
                transport: {
                    read: "<?php echo $exepath; ?>documents/documents_service_forAdmin"
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
                { field: "document_id", title: "Action", width: 5, template: "<a href='<?php echo $exepath; ?>users/review_forAdmin?document_id=#: document_id #'>Review</a> | <a href='javascript:approveDocu(#: document_id #)'>Approve</a>"},
                //{ field: "user_id", title: "U_id", width: 40 },
                { field: "name", title: "User", width: 10 },
                { field: "title", title: "Title", width: 20 },
                //{ field: "content", title: "Content", width: 90 }, // could be too long to display. see content in review
                { field: "status", title: "Status", width: 5 },
                { field: "date_added", title: "Date added/edited", width: 20 },
                ]
        });
        
    });

function approveDocu(document_id){
    if(confirm("Are you sure you want to approve this document?")){
        window.location = '<?php echo $exepath; ?>users/commitApprove?document_id=' + document_id;
    }
}
</script>
</div>