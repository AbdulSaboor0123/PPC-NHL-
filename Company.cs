using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TransSeas.Models
{
    public class Company
    {
        public int  comp_id { get; set; }
        public string comp_code { get; set; }
        public string comp_name { get; set; }
        public string comp_address { get; set; }
        public string comp_address_sec { get; set; }
        public string comp_city { get; set; }
        public string comp_province { get; set; }
        public string comp_country { get; set; }
        public string comp_phone { get; set; }
        public string comp_fax { get; set; }
        public string comp_site { get; set; }
        public string comp_email { get; set; }
        public string comp_telephone { get; set; }
        public string comp_zipcode { get; set; }

    }
}