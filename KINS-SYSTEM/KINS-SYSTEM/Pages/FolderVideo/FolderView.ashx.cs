using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.SessionState;
using System.Runtime.Serialization;
using System.Web.Script.Serialization;
using System.IO;
using System.Net;

namespace KINS_SYSTEM.Pages.FolderVideo
{
    /// <summary>
    /// test1 的摘要说明
    /// </summary>
    public class test1 : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
            string[] files={};
            string[] fol = { };
            try
            {
                files = Directory.GetFiles(System.Web.HttpContext.Current.Server.MapPath("/") + data.F_adress);
                fol = Directory.GetDirectories(System.Web.HttpContext.Current.Server.MapPath("/") + data.F_adress);
            }catch(Exception e){
                context.Response.Write("");
            }
            int fileLength = files.Length;
            for (int i = 0; i < fileLength; i++) {
                files[i] = files[i].Split('\\')[files[i].Split('\\').Length - 1];
            }

            string content = "";
            for (int i = 0; i < fol.Length; i++)
            {
                fol[i] = fol[i].Split('\\')[fol[i].Split('\\').Length - 1];
                content += "|||" + fol[i];
            }


            for (int i = 0; i < files.Length; i++) {
                content += "|||" + files[i];
            }
            context.Response.Write(content);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
        public class Data {
            public string F_adress = "";
        }
    }
}