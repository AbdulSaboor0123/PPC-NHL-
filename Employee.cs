using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TransSeas.Models
{
    public class Employee
    {
        public int emp_id { get; set; }
        public string emp_code { get; set; }
        public string emp_name { get; set; }
        public int desg_id { get; set; }
        public string desg_role { get; set; }
        public string emp_phone { get; set; }
        public string emp_telephone { get; set; }
        public string emp_fax { get; set; }
        public string emp_email { get; set; }
        public string emp_address { get; set; }
        public string emp_address_sec { get; set; }
        public string emp_city { get; set; }
        public string emp_province { get; set; }
        public string emp_country { get; set; }
        public string emp_zipcode { get; set; }
        public int ofc_id { get; set; }
        public string ofc_name { get; set; }
    }
    public class Emp
    {
        public int emp_id { get; set; }
        public string emp_name { get; set; }
       
    }
    public class Count
    {
        public int count_id { get; set; }
        public string count_name { get; set; }

    }
    public class rol
    {
        public int desg_id { get; set; }
        public string desg_role { get; set; }

    }
}