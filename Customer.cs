using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TransSeas.Models
{
    public class Customer
    {
        public int cust_id { get; set; }
        public string cust_code { get; set; }
        public string cust_name { get; set; }
        public string cust_phone { get; set; }
        public string cust_email { get; set; }
        public string cust_address { get; set; }
        public string cust_address_sec { get; set; }
        public string cust_city { get; set; }
        public string cust_province { get; set; }
        public string cust_country { get; set; }
        public string cust_postalcode { get; set; }
        public int cp_id { get; set; }
        public string cp_name { get; set; }
        public string cust_telephone { get; set; }
        public string cust_fax { get; set; }
        public int ofc_id { get; set; }
        public string ofc_name { get; set; }
    }
    public class Cust
    {
        public int cust_id { get; set; }
        public string cust_name { get; set; }
    }
}