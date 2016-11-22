namespace WindowsFormsApplication1
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            Telerik.WinControls.UI.GridViewDecimalColumn gridViewDecimalColumn1 = new Telerik.WinControls.UI.GridViewDecimalColumn();
            Telerik.WinControls.UI.GridViewTextBoxColumn gridViewTextBoxColumn1 = new Telerik.WinControls.UI.GridViewTextBoxColumn();
            Telerik.WinControls.UI.GridViewTextBoxColumn gridViewTextBoxColumn2 = new Telerik.WinControls.UI.GridViewTextBoxColumn();
            Telerik.WinControls.UI.GridViewDateTimeColumn gridViewDateTimeColumn1 = new Telerik.WinControls.UI.GridViewDateTimeColumn();
            Telerik.WinControls.UI.GridViewDateTimeColumn gridViewDateTimeColumn2 = new Telerik.WinControls.UI.GridViewDateTimeColumn();
            Telerik.WinControls.UI.GridViewTextBoxColumn gridViewTextBoxColumn3 = new Telerik.WinControls.UI.GridViewTextBoxColumn();
            Telerik.WinControls.UI.GridViewTextBoxColumn gridViewTextBoxColumn4 = new Telerik.WinControls.UI.GridViewTextBoxColumn();
            this.button1 = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.radGridView1 = new Telerik.WinControls.UI.RadGridView();
            this.project3_474DataSet = new WindowsFormsApplication1.Project3_474DataSet();
            this.project3474DataSetBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.chatBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.chatTableAdapter = new WindowsFormsApplication1.Project3_474DataSetTableAdapters.ChatTableAdapter();
            this.radGridView2 = new Telerik.WinControls.UI.RadGridView();
            this.chatWSBindingSource = new System.Windows.Forms.BindingSource(this.components);
            ((System.ComponentModel.ISupportInitialize)(this.radGridView1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.radGridView1.MasterTemplate)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.project3_474DataSet)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.project3474DataSetBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.chatBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.radGridView2)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.radGridView2.MasterTemplate)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.chatWSBindingSource)).BeginInit();
            this.SuspendLayout();
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(50, 34);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(75, 23);
            this.button1.TabIndex = 0;
            this.button1.Text = "button1";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click_1);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(50, 100);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(35, 13);
            this.label1.TabIndex = 1;
            this.label1.Text = "label1";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(50, 134);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(35, 13);
            this.label2.TabIndex = 2;
            this.label2.Text = "label2";
            // 
            // radGridView1
            // 
            this.radGridView1.Location = new System.Drawing.Point(0, 240);
            // 
            // radGridView1
            // 
            gridViewDecimalColumn1.DataType = typeof(int);
            gridViewDecimalColumn1.FieldName = "Chat_id";
            gridViewDecimalColumn1.HeaderText = "Chat_id";
            gridViewDecimalColumn1.IsAutoGenerated = true;
            gridViewDecimalColumn1.Name = "Chat_id";
            gridViewDecimalColumn1.ReadOnly = true;
            gridViewTextBoxColumn1.FieldName = "Message";
            gridViewTextBoxColumn1.HeaderText = "Message";
            gridViewTextBoxColumn1.IsAutoGenerated = true;
            gridViewTextBoxColumn1.Name = "Message";
            gridViewTextBoxColumn2.FieldName = "Name";
            gridViewTextBoxColumn2.HeaderText = "Name";
            gridViewTextBoxColumn2.IsAutoGenerated = true;
            gridViewTextBoxColumn2.Name = "Name";
            gridViewDateTimeColumn1.FieldName = "Time";
            gridViewDateTimeColumn1.HeaderText = "Time";
            gridViewDateTimeColumn1.IsAutoGenerated = true;
            gridViewDateTimeColumn1.Name = "Time";
            this.radGridView1.MasterTemplate.Columns.AddRange(new Telerik.WinControls.UI.GridViewDataColumn[] {
            gridViewDecimalColumn1,
            gridViewTextBoxColumn1,
            gridViewTextBoxColumn2,
            gridViewDateTimeColumn1});
            this.radGridView1.MasterTemplate.DataSource = this.chatBindingSource;
            this.radGridView1.Name = "radGridView1";
            this.radGridView1.Size = new System.Drawing.Size(224, 305);
            this.radGridView1.TabIndex = 3;
            this.radGridView1.Text = "radGridView1";
            this.radGridView1.Click += new System.EventHandler(this.radGridView1_Click);
            // 
            // project3_474DataSet
            // 
            this.project3_474DataSet.DataSetName = "Project3_474DataSet";
            this.project3_474DataSet.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
            // 
            // project3474DataSetBindingSource
            // 
            this.project3474DataSetBindingSource.DataSource = this.project3_474DataSet;
            this.project3474DataSetBindingSource.Position = 0;
            // 
            // chatBindingSource
            // 
            this.chatBindingSource.DataMember = "Chat";
            this.chatBindingSource.DataSource = this.project3474DataSetBindingSource;
            // 
            // chatTableAdapter
            // 
            this.chatTableAdapter.ClearBeforeFill = true;
            // 
            // radGridView2
            // 
            this.radGridView2.Location = new System.Drawing.Point(230, 240);
            // 
            // radGridView2
            // 
            gridViewDateTimeColumn2.DataType = typeof(System.Nullable<System.DateTime>);
            gridViewDateTimeColumn2.FieldName = "ChatDate";
            gridViewDateTimeColumn2.HeaderText = "ChatDate";
            gridViewDateTimeColumn2.IsAutoGenerated = true;
            gridViewDateTimeColumn2.Name = "ChatDate";
            gridViewTextBoxColumn3.FieldName = "Name";
            gridViewTextBoxColumn3.HeaderText = "Name";
            gridViewTextBoxColumn3.IsAutoGenerated = true;
            gridViewTextBoxColumn3.Name = "Name";
            gridViewTextBoxColumn4.FieldName = "Message";
            gridViewTextBoxColumn4.HeaderText = "Message";
            gridViewTextBoxColumn4.IsAutoGenerated = true;
            gridViewTextBoxColumn4.Name = "Message";
            this.radGridView2.MasterTemplate.Columns.AddRange(new Telerik.WinControls.UI.GridViewDataColumn[] {
            gridViewDateTimeColumn2,
            gridViewTextBoxColumn3,
            gridViewTextBoxColumn4});
            this.radGridView2.MasterTemplate.DataSource = this.chatWSBindingSource;
            this.radGridView2.Name = "radGridView2";
            this.radGridView2.Size = new System.Drawing.Size(240, 305);
            this.radGridView2.TabIndex = 4;
            this.radGridView2.Text = "radGridView2";
            // 
            // chatWSBindingSource
            // 
            this.chatWSBindingSource.DataSource = typeof(WindowsFormsApplication1.ChatWebService.ChatWS);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(716, 546);
            this.Controls.Add(this.radGridView2);
            this.Controls.Add(this.radGridView1);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.button1);
            this.Name = "Form1";
            this.Text = "Form1";
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.radGridView1.MasterTemplate)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.radGridView1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.project3_474DataSet)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.project3474DataSetBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.chatBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.radGridView2.MasterTemplate)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.radGridView2)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.chatWSBindingSource)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private Telerik.WinControls.UI.RadGridView radGridView1;
        private System.Windows.Forms.BindingSource project3474DataSetBindingSource;
        private Project3_474DataSet project3_474DataSet;
        private System.Windows.Forms.BindingSource chatBindingSource;
        private Project3_474DataSetTableAdapters.ChatTableAdapter chatTableAdapter;
        private Telerik.WinControls.UI.RadGridView radGridView2;
        private System.Windows.Forms.BindingSource chatWSBindingSource;
    }
}

