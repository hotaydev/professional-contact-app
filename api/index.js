import express from "express";

const app = express();
app.disable("x-powered-by");

app.get("/v/", async (req, res) => {
  const vCardString = req.query.vcard;

  if (!vCardString) {
    res.status(400).send("Lack of vCard String");
  }

  // Set headers to initiate a file download
  res.setHeader("Content-Type", "text/vcard");
  res.setHeader("Content-Disposition", 'inline; filename="contact.vcf"');

  // Send the vCard string as the response
  res.send(vCardString);
});

app.get("/", async (req, res) => {
  res.send("https://github.com/hotaydev/professional-contact-nfc/tree/main/api");
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
