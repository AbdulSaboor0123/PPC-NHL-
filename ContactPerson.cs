using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace TransSeas.Models
{   
    
    public class ContactPerson
    {   
        public int cp_id { get; set; }
        [Required]
        public string cp_code { get; set; }
        [Required]
        public string cp_name { get; set; }
        [Required]
        public string cp_phone { get; set; }
        [Required]
        public string cp_email { get; set; }
        [Required]
        public string cp_address { get; set; }
        [Required]
        public string cp_address_sec { get; set; }
        [Required]
        public string cp_city { get; set; }
        [Required]
        public string cp_province { get; set; }
        [Required]
        public string cp_country { get; set; }
        [Required]
        public string cp_postalcode { get; set; }
        public int ofc_id { get; set; }
        public string ofc_name { get; set; }
    }
    public class CP
    {
        public int cp_id { get; set; }
        public string cp_name { get; set; }
    }
}