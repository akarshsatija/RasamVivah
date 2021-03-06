﻿using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Collections;
using System.Net;
using System.Xml;
using System.Data.SqlClient;
using System.Web.UI.HtmlControls;

public partial class membership : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            lbprice.Text = "0";


        if (Session["id"] != null)
        {

            hideExtra();
        
        
        }

        if (!IsPostBack)
        {

            BindMotherTongue();
            bindReligion();
            bindMarital();
            bindWorking_with();
            bindCity();
            bindDegree();
            bindCountry();



            for (int i = 18; i <= 65; i++)
            {


                ListItem l = new ListItem();
                l = new ListItem(i.ToString() + " Yrs", i.ToString());
                drpadvlwrage.Items.Add(l);
                //drpadvuprage.Items.Add(l);

            }

            for (int i = 18; i <= 65; i++)
            {


                ListItem l = new ListItem();
                l = new ListItem(i.ToString() + " Yrs", i.ToString());
                // drpadvlwrage.Items.Add(l);
                drpadvuprage.Items.Add(l);

            }

            drpadvlwrage.SelectedValue = "18";
            drpadvuprage.SelectedValue = "30";
            //drpadvlwrage.SelectedValue = "21";
            //l = new ListItem("Min", "0");
            //drpadvlwrage.Items.Insert(0, l);
            //drpadvuprage.Items.Insert(0, l);

        }
    }


    protected void lvplan_ItemDataBound(object sender, ListViewItemEventArgs e)
    {

       
    }





    protected void lvplan_ItemCommand(object sender, ListViewCommandEventArgs e)
    {
        try
        {
            //if (e.CommandName == "1")
            //{
            //    lbprice.Text = (e.Item.FindControl("priceLabel") as Label).Text;
            //    lbservices.Text = (e.Item.FindControl("planLabel") as Label).Text + ":" + (e.Item.FindControl("priceLabel") as Label).Text + ":" + (e.Item.FindControl("durationLabel") as Label).Text;
            //}

            //else if (e.CommandName == "2")
            //{
            //    lbprice.Text = "6995";
            //}

            //else if (e.CommandName == "3")
            //{
            //    lbprice.Text = "12595";
            //}


            for (int i = 1; i < 10; i++)
            {
                if (e.CommandName.Equals(i.ToString()))
                {
                    lbprice.Text = (e.Item.FindControl("priceLabel") as Label).Text;
                    lbservices.Text = (e.Item.FindControl("planLabel") as Label).Text + ":" + (e.Item.FindControl("priceLabel") as Label).Text + ":" + (e.Item.FindControl("durationLabel") as Label).Text;
                }
            
            
            }

            
        }
        catch { }
    }

    protected void hideExtra() {

        divPayNow.Visible = false;
    
    
    
    }
    protected void btnbuy_Click(object sender, EventArgs e)
    {
        if (Session["id"] == null)
        {

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.Append("<script>");

            sb.Append("window.alert(\"Login To Proceed! \");");

            sb.Append("</script>");

            Page.RegisterStartupScript("test", sb.ToString());

            //pop up login To proceed


        }
        else
        { 
        
        
        
        
        
        
        }
    }

    protected void btsearch_Click(object sender, EventArgs e)
    {
        string search_url = "search.aspx?result=1";


        if (!rbtnlooking.SelectedValue.ToString().Equals("")) // is type se
        {
            search_url += "&gender=" + rbtnlooking.SelectedValue.ToString();
        }


        if (!drpadvlwrage.SelectedValue.Equals("0"))
        {
            search_url += "&agel=" + drpadvlwrage.SelectedValue.ToString();
        }

        if (!drpadvuprage.SelectedValue.Equals("0"))
        {
            search_url += "&ageu=" + drpadvuprage.SelectedValue.ToString();
        }


        if (!drpadvmarital.SelectedValue.Equals("0")) //like this
        {
            search_url += "&m_status1=" + drpadvmarital.SelectedValue.ToString();
        }

        if (!drpadvreligion.SelectedValue.Equals("0"))
        {
            search_url += "&religion1=" + drpadvreligion.SelectedValue.ToString();
        }

        if (!drpadvmthrtongue.SelectedValue.Equals("0"))
        {
            search_url += "&m_tongue1=" + drpadvmthrtongue.SelectedValue.ToString();
        }

        if (!drpadvcountry.SelectedValue.Equals("0"))
        {
            search_url += "&country1=" + drpadvcountry.SelectedValue.ToString();
        }
        if (!drpcity.SelectedValue.Equals("0"))
        {
            search_url += "&city1=" + drpcity.SelectedValue.ToString();
        }

        if (!drpadveducation.SelectedValue.Equals("0"))
        {
            search_url += "&edu1=" + drpadveducation.SelectedValue.ToString();
        }

        //if (!drpadvoccupation.SelectedValue.Equals("0"))
        //{
        //    search_url += "&occ1=" + drpadvoccupation.SelectedValue.ToString();
        //}

        if (!drpadvworkstatus.SelectedValue.Equals("0"))
        {
            search_url += "&work_s1=" + drpadvworkstatus.SelectedValue.ToString();
        }

        if (chkphotos.Checked == true)
        {
            search_url += "&photos=1";
        }

        Response.Redirect(search_url);


    }
    protected void BindMotherTongue()
    {

        try
        {
            XmlTextReader xmlreader = new XmlTextReader(Server.MapPath("xml//mother_tongue.xml"));

            DataSet ds = new DataSet();
            ds.ReadXml(xmlreader);
            xmlreader.Close();
            if (ds.Tables.Count != 0)
            {
                drpadvmthrtongue.DataSource = ds;
                drpadvmthrtongue.DataTextField = "Text";
                drpadvmthrtongue.DataValueField = "Value";
                drpadvmthrtongue.DataBind();
            }

            //drpadvmthrtongue.Items.Insert(0, new ListItem("Mother Tongue", "0"));
            drpadvmthrtongue.Items.RemoveAt(0);
            drpadvmthrtongue.Items.Insert(0, new ListItem("Mother Tongue", "0"));
        }
        catch (Exception ex)
        {


        }


    }

    protected void bindReligion()
    {

        try
        {
            XmlTextReader xmlreader = new XmlTextReader(Server.MapPath("xml//religion.xml"));
            DataSet ds = new DataSet();
            ds.ReadXml(xmlreader);

            if (ds.Tables.Count != 0)
            {
                drpadvreligion.DataSource = ds;
                drpadvreligion.DataTextField = "Text";
                drpadvreligion.DataValueField = "Value";
                drpadvreligion.DataBind();
            }
            drpadvreligion.Items.RemoveAt(0);
            drpadvreligion.Items.Insert(0, new ListItem("Religion", "0"));
            xmlreader.Close();
        }
        catch (Exception ex)
        {
            throw ex;

        }

    }

    protected void drpadvcountry_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindCity(drpadvcountry.SelectedValue.ToString());






    }

    protected void bindCity(string country = "")
    {

        try
        {
            XmlTextReader xmlreader;


            if (country.Equals("356"))
            {

                xmlreader = new XmlTextReader(Server.MapPath("xml//cities.xml"));
            }
            else if (country.Equals("840"))
            {

                xmlreader = new XmlTextReader(Server.MapPath("xml//UScities.xml"));
            }

            else
            {

                xmlreader = new XmlTextReader(Server.MapPath("xml//other.xml"));

            }




            DataSet ds = new DataSet();
            ds.ReadXml(xmlreader);
            xmlreader.Close();
            //if (ds.Tables.Count != 0)
            //{
            drpcity.DataSource = ds;
            drpcity.DataTextField = "Text";
            drpcity.DataValueField = "Value";
            drpcity.DataBind();


            drpcity.Items.RemoveAt(0);
            drpcity.Items.Insert(0, new ListItem("City", "0"));

            //00000
            //string xmlFile = Server.MapPath("xml//country.xml");
            //XmlReaderSettings settings = new XmlReaderSettings();
            //settings.IgnoreComments = true;
            //settings.IgnoreWhitespace = true;
            //try
            //{
            //    using (XmlReader reader = XmlReader.Create(xmlFile, settings))
            //    {

            //        while (reader.Read())
            //        {
            //            if (reader.NodeType == XmlNodeType.Element)
            //            {

            //                //<option Text="Anguilla" Value="660" iso="AI" isd="264" ></option>
            //                if (reader.Name == "option")
            //                {
            //                    if (reader.GetAttribute("Value").ToString().Equals(drpadvcountry.SelectedValue.ToString()))
            //                    {
            //                        //xmlContent = reader.GetAttribute("isd").ToString();

            //                    }

            //                }


            //            }
            //        }
            //    }
            //}
            //catch (Exception ex)
            //{

            //}


            //--------------

            // }
        }
        catch (Exception ex)
        {


        }


    }

    protected void bindCountry()
    {

        try
        {
            XmlTextReader xmlreader = new XmlTextReader(Server.MapPath("xml//country.xml"));
            DataSet ds = new DataSet();
            ds.ReadXml(xmlreader);

            if (ds.Tables.Count != 0)
            {
                drpadvcountry.DataSource = ds;
                drpadvcountry.DataTextField = "Text";
                drpadvcountry.DataValueField = "Value";
                drpadvcountry.DataBind();
            }
            drpadvcountry.Items.RemoveAt(0);
            drpadvcountry.Items.Insert(0, new ListItem("Country", "0"));
            xmlreader.Close();
        }
        catch (Exception ex)
        {
            throw ex;

        }

    }

    protected void bindMarital()
    {

        try
        {
            XmlTextReader xmlreader = new XmlTextReader(Server.MapPath("xml//marital.xml"));
            DataSet ds = new DataSet();
            ds.ReadXml(xmlreader);

            if (ds.Tables.Count != 0)
            {
                drpadvmarital.DataSource = ds;
                drpadvmarital.DataTextField = "Text";
                drpadvmarital.DataValueField = "Value";
                drpadvmarital.DataBind();
            }
            drpadvmarital.Items.RemoveAt(0);
            drpadvmarital.Items.Insert(0, new ListItem("Marital Status", "0"));
            //chkadvmarital.Items.RemoveAt(0);
            xmlreader.Close();
        }
        catch (Exception ex)
        {
            throw ex;

        }

    }

    protected void bindWorking_with()
    {

        try
        {
            XmlTextReader xmlreader = new XmlTextReader(Server.MapPath("xml//working_with.xml"));

            DataSet ds = new DataSet();
            ds.ReadXml(xmlreader);
            xmlreader.Close();
            if (ds.Tables.Count != 0)
            {
                drpadvworkstatus.DataSource = ds;
                drpadvworkstatus.DataTextField = "Text";
                drpadvworkstatus.DataValueField = "Value";
                drpadvworkstatus.DataBind();

            }
            drpadvworkstatus.Items.RemoveAt(0);
            drpadvworkstatus.Items.Insert(0, new ListItem("Work Status", "0"));
            // chkadvworkstatus.Items.RemoveAt(0);
            xmlreader.Close();

        }
        catch (Exception ex)
        {


        }


    }
    protected void bindDegree()
    {

        try
        {
            XmlTextReader xmlreader = new XmlTextReader(Server.MapPath("xml//degree.xml"));

            DataSet ds = new DataSet();
            ds.ReadXml(xmlreader);
            xmlreader.Close();
            if (ds.Tables.Count != 0)
            {
                drpadveducation.DataSource = ds;
                drpadveducation.DataTextField = "Text";
                drpadveducation.DataValueField = "Value";
                drpadveducation.DataBind();



            }

            drpadveducation.Items.Insert(0, new ListItem("Education", "0"));
            //chkadveducation.Items.Insert(0, new ListItem("Doesn't matter", "0"));
            xmlreader.Close();

        }
        catch (Exception ex)
        {


        }

    }
    protected void bindCaste(string religion)
    {

        try
        {
            XmlTextReader xmlreader;


            if (religion.Equals("1"))
                xmlreader = new XmlTextReader(Server.MapPath("xml//hindu.xml"));
            else if (religion.Equals("2"))
                xmlreader = new XmlTextReader(Server.MapPath("xml//muslim.xml"));
            else if (religion.Equals("3"))
                xmlreader = new XmlTextReader(Server.MapPath("xml//christian.xml"));
            else if (religion.Equals("4"))
                xmlreader = new XmlTextReader(Server.MapPath("xml//sikh.xml"));
            else if (religion.Equals("5"))
                xmlreader = new XmlTextReader(Server.MapPath("xml//other.xml"));
            else if (religion.Equals("6"))
                xmlreader = new XmlTextReader(Server.MapPath("xml//jain.xml"));
            else if (religion.Equals("7"))
                xmlreader = new XmlTextReader(Server.MapPath("xml//other.xml"));
            else if (religion.Equals("8"))
                xmlreader = new XmlTextReader(Server.MapPath("xml//other.xml"));
            else
                xmlreader = new XmlTextReader(Server.MapPath("xml//other.xml"));






            DataSet ds = new DataSet();
            ds.ReadXml(xmlreader);
            xmlreader.Close();
            //if (ds.Tables.Count != 0)
            //{
            drpcaste.DataSource = ds;
            drpcaste.DataTextField = "Text";
            drpcaste.DataValueField = "Value";
            drpcaste.DataBind();






            //--------------

            // }
        }
        catch (Exception ex)
        {


        }


    }

    protected void drpadvreligion_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindCaste(drpadvreligion.SelectedValue.ToString());
    }
}