using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TransSeas.Models
{
    public class Agent
    {
        public int fa_id { get; set; }
        public string fa_code { get; set; }
         public string fa_name { get; set; }
        public string fa_phone { get; set; }
        public string fa_email { get; set; }
        public string fa_address { get; set; }
        public string fa_address_sec { get; set; }
        public string fa_city { get; set; }
        public string fa_province { get; set; }
        public string fa_country { get; set; }
        public string fa_postalcode { get; set; }
        public int ofc_id { get; set; }
        public  string ofc_name { get; set; }
    }
   
}