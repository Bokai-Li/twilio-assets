import express, { RequestHandler } from "express";
import { body } from "express-validator";
import { StatusCodes } from "http-status-codes";
import { Twilio } from "twilio";
import { HTTPError } from "./errorHandler";

// TODO: Load twilio info to secrets in container
const accountSid = process.env.TWILIO_ACCOUNT_SID;
const authToken = process.env.TWILIO_AUTH_TOKEN;
const verifySid= process.env.VERIFY_SERVICE_SID;
if (!process.env.TWILIO_ACCOUNT_SID) {
  console.log("ERROR! `TWILIO_ACCOUNT_SID` not set as env variable.");
}
if (!process.env.TWILIO_AUTH_TOKEN) {
  console.log("ERROR! `TWILIO_AUTH_TOKEN` not set as env variable.");
}
if (!process.env.VERIFY_SERVICE_SID) {
  console.log("ERROR! `VERIFY_SERVICE_SID` not set as env variable.");
}

const client = new Twilio(accountSid || "", authToken || "");

const twilioRouter = express.Router();

const startVerificationValidator = () => {
  return [
    body("countryCode").isString(),
    body("phoneNumber").isString(),
    body("via").isString(),
  ];
};

const checkVerificationValidator = () => {
  return [
    body("countryCode").isString(),
    body("phoneNumber").isString(),
    body("verificationCode").isString(),
  ];
};

const startVerificationHandler: RequestHandler = (req, res, next) => {
  const countryCode = req.body.countryCode;
  const phoneNumber = req.body.phoneNumber;
  const via = req.body.via as string;

  console.info(
    "sending verification code to ...",
    `+${countryCode}${phoneNumber}`,
    "via...",
    `${via}`
  );

  client.verify
    .services(verifySid || "")
    .verifications.create({ to: `+${countryCode}${phoneNumber}`, channel: via })
    .then((resp) => res.json(resp))
    .catch((error) => {
      console.error(error);
      next(new HTTPError(StatusCodes.INTERNAL_SERVER_ERROR));
      return;
    });
};

const checkVerificationHandler: RequestHandler = (req, res, next) => {
  const countryCode = req.body.countryCode;
  const phoneNumber = req.body.phoneNumber;
  const code = req.body.verificationCode as string;
  client.verify
    .services(process.env.VERIFY_SERVICE_SID || "")
    .verificationChecks.create({
      to: `+${countryCode}${phoneNumber}`,
      code: code,
    })
    .then((verification_check) => {
      res.json(verification_check);
    })
    .catch((error) => {
      console.error(error);
      next(new HTTPError(StatusCodes.INTERNAL_SERVER_ERROR));
      return;
    });
};

twilioRouter.post(
  "/start",
  startVerificationValidator(),
  startVerificationHandler
);

twilioRouter.post(
  "/check",
  checkVerificationValidator(),
  checkVerificationHandler
);

export default twilioRouter;

