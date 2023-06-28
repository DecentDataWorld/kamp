import I18n from '../i18n-js/locales.js'

export default function UsersList() {

  return (
    <div>this is {I18n.t('controllers.users')}  NON-react component with data passed: 
    <ul>
      <li>{props.adminrole}</li>
      <li>{props.memberrole}</li>
    </ul>
  
  </div>
  )

}
