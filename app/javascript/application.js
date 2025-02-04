// Import Turbo (Hotwire)
import { Turbo } from "turbo-rails";

// Import Rails UJS for handling CSRF tokens, form submissions, etc.
import Rails from '@rails/ujs';
Rails.start();

// Import any other JavaScript you might need (controllers, etc.)
import "controllers";

