resource "auth0_email" "sendgrid_email_provider" {
  name                 = "sendgrid"
  enabled              = true
  default_from_address = "hello@supercmo.ai"

  credentials {
    api_key = var.sengrid_key
  }
}

resource "auth0_email_template" "user_invite_template" {
  depends_on = [auth0_email.sendgrid_email_provider]

  template                = "user_invitation"
  from                    = "hello@supercmo.ai"
  result_url              = join("", [var.domain, "/auth/login"])
  subject                 = "You are being invited to SuperCMO"
  syntax                  = "liquid"
  url_lifetime_in_seconds = 86400
  enabled                 = true

  body = <<-EOT
<html>
  <head>
    <style type="text/css">
      .ExternalClass,.ExternalClass div,.ExternalClass font,.ExternalClass p,.ExternalClass span,.ExternalClass td,img {line-height: 100%;}#outlook a {padding: 0;}.ExternalClass,.ReadMsgBody {width: 100%;}a,blockquote,body,li,p,table,td {-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;}table,td {mso-table-lspace: 0;mso-table-rspace: 0;}img {-ms-interpolation-mode: bicubic;border: 0;height: auto;outline: 0;text-decoration: none;}table {border-collapse: collapse !important;}#bodyCell,#bodyTable,body {height: 100% !important;margin: 0;padding: 0;font-family: ProximaNova, sans-serif;}#bodyCell {padding: 20px;}#bodyTable {width: 600px;}@font-face {font-family: ProximaNova;src: url(https://cdn.auth0.com/fonts/proxima-nova/proximanova-regular-webfont-webfont.eot);src: url(https://cdn.auth0.com/fonts/proxima-nova/proximanova-regular-webfont-webfont.eot?#iefix)format("embedded-opentype"),url(https://cdn.auth0.com/fonts/proxima-nova/proximanova-regular-webfont-webfont.woff) format("woff");font-weight: 400;font-style: normal;}@font-face {font-family: ProximaNova;src: url(https://cdn.auth0.com/fonts/proxima-nova/proximanova-semibold-webfont-webfont.eot);src: url(https://cdn.auth0.com/fonts/proxima-nova/proximanova-semibold-webfont-webfont.eot?#iefix)format("embedded-opentype"),url(https://cdn.auth0.com/fonts/proxima-nova/proximanova-semibold-webfont-webfont.woff) format("woff");font-weight: 600;font-style: normal;}@media only screen and (max-width: 480px) {#bodyTable,body {width: 100% !important;}a,blockquote,body,li,p,table,td {-webkit-text-size-adjust: none !important;}body {min-width: 100% !important;}#bodyTable {max-width: 600px !important;}#signIn {max-width: 280px !important;}}
    </style>
  </head>
  <body>
    <center>
      <table
        style='width: 600px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;mso-table-lspace: 0pt;mso-table-rspace: 0pt;margin: 0;padding: 0;font-family: "ProximaNova", sans-serif;border-collapse: collapse !important;height: 100% !important;'
        align="center"
        border="0"
        cellpadding="0"
        cellspacing="0"
        height="100%"
        width="100%"
        id="bodyTable"
      >
        <tr>
          <td
            align="center"
            valign="top"
            id="bodyCell"
            style='-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;mso-table-lspace: 0pt;mso-table-rspace: 0pt;margin: 0;padding: 20px;font-family: "ProximaNova", sans-serif;height: 100% !important;'
          >
            <div class="main">
              <p
                style="text-align: center;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%; margin-bottom: 30px;"
              >
                <img
                  src={{ application.logo_uri }}
                  width="350"
                  alt="Super CMO"
                  style="-ms-interpolation-mode: bicubic;border: 0;height: auto;line-height: 100%;outline: none;text-decoration: none;"
                />
              </p>

              <p style="font-size: 20px; padding:0 20px; margin:0">
                Hey There 👋, {{ inviter.name }} is using SuperCMO’s Generative AI Engine to turbocharge ads for <strong>{{ organization.display_name }}</strong>.
              </p>
              <p style="font-size: 14px; padding:0 20px; margin:5px">
                They have invited you to join their organization on SuperCMO.
                Click on Accept Invitation below to accept the invite or copy-paste the URL into your browser.
              </p>
              <p style="margin-top: 3rem">
                <a href="{{ url }}" style="text-decoration:none; background-color: #9c27b0; color: #ffffff; padding: 12px 16px; box-shadow: rgba(0, 0, 0, 0.2) 0px 3px 1px -2px, rgba(0, 0, 0, 0.14) 0px 2px 2px 0px, rgba(0, 0, 0, 0.12) 0px 1px 5px 0px">
                ACCEPT INVITATION
                </a>
              </p>
              <p style="margin-top: 2rem; font-weight: 500; font-size: 14px;">
                <span><strong>Invitation Link:&nbsp;</strong></span>
                <a href="{{ url | escape }}" style="color:#0a84ae; text-decoration:none">{{ url | escape }}</a>
              </p>
              <br /><br />
              <hr style="border: 2px solid #EAEEF3; border-bottom: 0; margin: 20px 0;" />
              <p style="text-align: center;color: #A9B3BC;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;">
                If you are not sure why you’re receiving this, please contact us at
                <a href="mailto:{{ support_email }}" style="color:#0a84ae;text-decoration:none">{{ support_email }}</a>
              </p>
            </div>
          </td>
        </tr>
      </table>
    </center>
  </body>
</html>
    EOT
}
