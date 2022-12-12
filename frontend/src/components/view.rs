use yew::prelude::*;
use yew_oauth2::context::OAuth2Context;

#[derive(Clone, Debug, PartialEq, Properties)]
pub struct ContextProps {
    pub auth: OAuth2Context,
}

#[function_component(ViewAuthContext)]
pub fn view_context(props: &ContextProps) -> Html {
    html!(
        <dl>
            <dt> { "Context" } </dt>
            <dd>
                <code><pre>
                    { format!("{:#?}", props.auth) }
                </pre></code>
            </dd>
        </dl>
    )
}
