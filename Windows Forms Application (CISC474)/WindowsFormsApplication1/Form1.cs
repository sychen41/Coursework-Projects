using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;


namespace WindowsFormsApplication1
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        ChatWebService.WebService1 obj = new ChatWebService.WebService1();


        private void button1_Click_1(object sender, EventArgs e)
        {
            List<string> messages = new List<string>();
            foreach (var element in obj.GetAllChats())
            {
                messages.Add(element.Message);
            }
            string display_message = string.Join(",", messages.ToArray());
            label1.Text = display_message;

            List<string> names = new List<string>();
            foreach (var element in obj.GetAllChats())
            {
                names.Add(element.Name);
            }
            string display_names = string.Join(",", names.ToArray());
            label2.Text = display_names;

        }

        private void radGridView1_Click(object sender, EventArgs e)
        {

        }

        private void Form1_Load(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the 'project3_474DataSet.Chat' table. You can move, or remove it, as needed.
            this.chatTableAdapter.Fill(this.project3_474DataSet.Chat);

        }

    }
}
