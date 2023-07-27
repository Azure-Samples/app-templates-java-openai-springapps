package com.microsoft.azure.samples.aishoppingcartservice.cartitem.exception;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ProblemDetail;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

@ControllerAdvice
public class RestResponseEntityExceptionHandler extends ResponseEntityExceptionHandler {
  @ExceptionHandler({EmptyCartException.class})
  protected ResponseEntity<Object> handleEmptyCartException(final Exception exception,
                                                            final WebRequest request) {
    return this.handleException(exception, request, HttpStatus.BAD_REQUEST);
  }

  @ExceptionHandler({CartItemNotFoundException.class})
  protected ResponseEntity<Object> handleCartItemNotFoundException(final Exception exception,
                                                                   final WebRequest request) {
    return this.handleException(exception, request, HttpStatus.NOT_FOUND);
  }

  /**
   * Handle an exception with a given HTTP status and return a {@link ResponseEntity} that corresponds
   * to the error to return to the client. The response body follow the RFC 7807 standard.
   * <p>
   * <p>
   * The method creates a {@link ProblemDetail} instance from the given exception, status and request.
   * The default detail of the problem details is the exception's message. This problem detail
   * object is then used as the body when calling
   * {@link ResponseEntityExceptionHandler#handleExceptionInternal(Exception, Object, HttpHeaders, HttpStatusCode, WebRequest)}.
   *
   * @param exception The exception
   * @param request   The request
   * @param status    The status representing the problem
   * @return A {@link ResponseEntity} with the problem details as the body
   */
  private ResponseEntity<Object> handleException(final Exception exception,
                                                 final WebRequest request,
                                                 final HttpStatus status) {
    final ProblemDetail body = this.createProblemDetail(exception, status, exception.getMessage(),
        null, null, request);
    return this.handleExceptionInternal(exception, body, new HttpHeaders(), status, request);
  }
}
