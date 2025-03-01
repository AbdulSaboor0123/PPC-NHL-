using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TransSeas.Models
{
    public class Category
    {
        public int cat_id { get; set; }
        public string cat_desc { get; set; }
        public int ofc_id { get; set; }
        public string ofc_name { get; set; }
    }
}