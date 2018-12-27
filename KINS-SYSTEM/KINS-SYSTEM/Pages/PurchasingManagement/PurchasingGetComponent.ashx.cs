using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using KINS_SYSTEM.ImportClass;
using System.Data;
using System.Runtime.Serialization;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace KINS_SYSTEM.Pages.PurchasingManagement
{
    /// <summary>
    /// PurchasingGetComponent 的摘要说明
    /// </summary>
    public class PurchasingGetComponent : IHttpHandler, System.Web.SessionState.IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
            data.company = context.Session["company"].ToString();
            context.Response.Write(getComponent(data));
        }

        private string getComponent(Data data) {
            string sqlStr = "select * from K_Component where Cp_company='" + data.company + "' and Cp_isValid='1'";
            if (data.Cp_manufacturerId != "")
                sqlStr += "and Cp_manufacturerId='" + data.Cp_manufacturerId + "'";
            if(data.Cp_typeId!="")
                sqlStr += " and Cp_typeId='" + data.Cp_typeId + "'" ;
            sqlStr += "order by Cp_editDate";
            DbSql ds = new DbSql();
            DataSet dset = new DataSet();
            dset = ds.FillDs(sqlStr);
            return (JsonConvert.SerializeObject(dset, new DataTableConverter()));
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        public class Data
        {
            public string Cp_manufacturerId = "";
            public string Cp_typeId = "", company = "";
        }
    }
}