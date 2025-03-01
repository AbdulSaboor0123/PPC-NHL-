using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TransSeas.Models
{
    public class LovCompany
    {
        public int comp_id { get; set; }
        public string comp_name { get; set; }
    }
    public class LovCountry
    {
        public int count_id { get; set; }
        public string count_name { get; set; }
    }
    public class LovOffices
    {
        public int ofc_id { get; set; }
        public string ofc_name { get; set; }
    }
}