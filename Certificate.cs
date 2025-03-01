using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TransSeas.Models
{
   
        public class CertificateMT
        {
            public int cert_ids { get; set; }
            public string cert_inv_no { get; set; }
            public int cert_skipper_id { get; set; }
            public string cert_skipper{ get; set; }
            public int cert_far_agent_id { get; set; }
            public string cert_far_agent { get; set; }
             public string cert_exp_reff { get; set; }
            public int cert_consignee_id { get; set; }
            public string cert_consignee { get; set; }
            public string cert_reciept_place { get; set; }
            public int trans_id { get; set; }
            public string trans_desc { get; set; }
            public int proj_id { get; set; }
            public string proj_name { get; set; }
        public int ofc_id { get; set; }
        public string ofc_name { get; set; }
        public string cert_date { get; set; }
    }

        public class CertificateDT
        {
            public int cert_det_id { get; set; }
            public int cert_ids { get; set; }
            public string cert_container_no { get; set; }
            public string cert_package_no { get; set; }
            public string cert_desc { get; set; }
            public float cert_gross_wt { get; set; }
            public string cert_origin { get; set; }
        }

}