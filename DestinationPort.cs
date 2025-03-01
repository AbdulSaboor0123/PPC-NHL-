using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TransSeas.Models
{
    public class DestinationPort
    {
        public int dest_id { get; set; }
        public string dest_code { get; set; }
        public string dest_desc { get; set; }
        public string dest_country { get; set; }
    }
}